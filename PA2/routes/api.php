<?php

use App\Http\Controllers\API\ProductApiController;
use App\Http\Controllers\API\CategoryApiController;
use App\Http\Controllers\API\FavoriteController;
use App\Http\Controllers\API\CartController;
use App\Http\Controllers\API\OrderApiController; 
use Illuminate\Support\Facades\Route;

// Routes untuk Produk
Route::prefix('admin')->group(function () {
    Route::get('/products', [ProductApiController::class, 'index']);
    Route::post('/products', [ProductApiController::class, 'store']);
    Route::get('/products/{id}', [ProductApiController::class, 'show']);
    Route::put('/products/{id}', [ProductApiController::class, 'update']);
    Route::delete('/products/{id}', [ProductApiController::class, 'destroy']);
});

// Routes untuk kategori admin
Route::prefix('admin/category')->group(function () {
    Route::get('/index', [CategoryApiController::class, 'index']);
    Route::post('/store', [CategoryApiController::class, 'store']);
    Route::put('/{category}/edit', [CategoryApiController::class, 'update']);  // edit untuk update
    Route::delete('/{category}/destroy', [CategoryApiController::class, 'destroy']);  // destroy untuk delete
});

// Routes untuk favorites
Route::get('/favorites', [FavoriteController::class, 'index']);
Route::post('/favorites', [FavoriteController::class, 'store']);
Route::delete('/favorites/{id}', [FavoriteController::class, 'destroy']);

// Routes yang memerlukan autentikasi
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/cart', [CartController::class, 'index']);
    Route::post('/cart', [CartController::class, 'store']);
    Route::put('/cart/{id}', [CartController::class, 'update']);
    Route::delete('/cart/{id}', [CartController::class, 'destroy']);

    // Routes untuk pesanan
    Route::get('/orders', [OrderApiController::class, 'index']);
    Route::get('/orders/{id}', [OrderApiController::class, 'show']);
});
