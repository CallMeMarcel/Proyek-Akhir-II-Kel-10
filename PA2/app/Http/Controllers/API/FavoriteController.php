<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Favorite;
use Illuminate\Http\Request;

class FavoriteController extends Controller
{
    // Tampilkan semua favorit user (bisa difilter pakai query param user_id)
    public function index(Request $request)
    {
        $favorites = Favorite::with('product')
            ->when($request->user_id, fn ($q) => $q->where('user_id', $request->user_id))
            ->get();

        return response()->json($favorites);
    }

    // Tambah favorit
    public function store(Request $request)
    {
        $request->validate([
            'user_id' => 'required|exists:users,id',
            'product_id' => 'required|exists:products,id',
        ]);

        $favorite = Favorite::firstOrCreate([
            'user_id' => $request->user_id,
            'product_id' => $request->product_id,
        ]);

        return response()->json($favorite, 201);
    }

    // Hapus favorit berdasarkan id
    public function destroy($id)
    {
        $favorite = Favorite::findOrFail($id);
        $favorite->delete();

        return response()->json(['message' => 'Favorite removed.']);
    }
}
