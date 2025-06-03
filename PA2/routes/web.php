<?php

use App\Http\Controllers\AdminController;
use App\Http\Controllers\Admin\KategoriController;
use App\Http\Controllers\Admin\ProductController;
use App\Http\Controllers\Admin\OrderController;
use App\Http\Controllers\Admin\ManualOrderController;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

// Redirect root ke dashboard
Route::get('/', function () {
    return redirect()->route('admin.dashboard');
});

// Hanya admin yang boleh akses area ini
Route::prefix('admin')->middleware(['auth', 'admin'])->group(function () {
    Route::get('/dashboard', [AdminController::class, 'dashboard'])->name('admin.dashboard');

    // Kategori
    Route::get('/kategori', [KategoriController::class, 'index'])->name('admin.kategori.index');
    Route::get('/kategori/create', [KategoriController::class, 'create'])->name('admin.kategori.create');
    Route::post('/kategori', [KategoriController::class, 'store'])->name('admin.kategori.store');
    Route::get('/kategori/{category}/edit', [KategoriController::class, 'edit'])->name('admin.kategori.edit');
    Route::put('/kategori/{category}', [KategoriController::class, 'update'])->name('admin.kategori.update');
    Route::delete('/kategori/{category}', [KategoriController::class, 'destroy'])->name('admin.kategori.destroy');

    // Produk
    Route::get('/produk', [ProductController::class, 'index'])->name('admin.produk.index');
    Route::get('/produk/create', [ProductController::class, 'create'])->name('admin.produk.create');
    Route::post('/produk', [ProductController::class, 'store'])->name('admin.produk.store');
    Route::get('/produk/{product}/edit', [ProductController::class, 'edit'])->name('admin.produk.edit');
    Route::put('/produk/{product}', [ProductController::class, 'update'])->name('admin.produk.update');
    Route::delete('/produk/{product}', [ProductController::class, 'destroy'])->name('admin.produk.destroy');

    // Order dan Manual Order
    Route::get('/orders', [OrderController::class, 'index'])->name('admin.orders.index');
    Route::delete('/orders/{order}', [OrderController::class, 'destroy'])->name('admin.orders.destroy');
    Route::put('/orders/{order}/complete', [OrderController::class, 'markAsComplete'])->name('admin.orders.complete');

    Route::get('/manual-order/create', [ManualOrderController::class, 'create'])->name('admin.order.create');
    Route::post('/manual-order', [ManualOrderController::class, 'store'])->name('admin.order.store');
});


Route::middleware(['guest'])->group(function () {
    Route::get('/login', fn () => Inertia::render('Auth/Login'))->name('login');
    Route::get('/register', fn () => Inertia::render('Auth/Register'))->name('register');
});

require __DIR__.'/auth.php';