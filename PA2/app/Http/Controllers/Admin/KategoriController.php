<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Redirect;
use Inertia\Inertia;

class KategoriController extends Controller
{
    /**
     * Menampilkan daftar kategori milik user yang sedang login.
     */
    public function index()
    {
        $categories = Category::where('user_id', auth()->id())->get();

        return Inertia::render('Admin/Kategori/index', [
            'categories' => $categories,
        ]);
    }

    /**
     * Menampilkan form untuk membuat kategori baru.
     */
    public function create()
    {
        return Inertia::render('Admin/Kategori/create');
    }

    /**
     * Simpan kategori baru ke database.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
        ]);

        Category::create([
            'name' => $validated['name'],
            'user_id' => auth()->id(),
        ]);

        return Redirect::route('admin.kategori.index')->with('success', 'Kategori berhasil ditambahkan');
    }

    /**
     * Update data kategori.
     */
    public function update(Request $request, Category $category)
    {
        $this->authorizeCategory($category);

        $validated = $request->validate([
            'name' => 'required|string|max:255',
        ]);

        $category->update(['name' => $validated['name']]);

        return Redirect::route('admin.kategori.index')->with('success', 'Kategori berhasil diperbarui');
    }

    /**
     * Hapus kategori dari database.
     */
    public function destroy(Category $category)
    {
        $this->authorizeCategory($category);

        $category->delete();

        return Redirect::route('admin.kategori.index')->with('success', 'Kategori berhasil dihapus');
    }

    /**
     * Cek apakah kategori dimiliki oleh user saat ini.
     */
    protected function authorizeCategory(Category $category)
    {
        if ($category->user_id !== auth()->id()) {
            abort(403, 'Anda tidak memiliki akses ke kategori ini.');
        }
    }
}
