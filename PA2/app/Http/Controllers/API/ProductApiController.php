<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Product;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\Request;

class ProductApiController extends Controller
{
    // Method untuk mengambil daftar produk
    public function index()
    {
        try {
            // Mengambil daftar produk dengan relasi kategori, diurutkan berdasarkan yang terbaru
            $products = Product::with('category')->latest()->get();
            
            return response()->json([
                'status' => 'success',
                'message' => 'Produk berhasil diambil.',
                'data' => $products
            ], 200);
        } catch (\Exception $e) {
            // Log exception untuk informasi lebih lanjut
            \Log::error('Error: ' . $e->getMessage());
    
            return response()->json([
                'status' => 'error',
                'message' => 'Terjadi kesalahan saat mengambil data produk.',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    // Method untuk mengambil produk berdasarkan ID
 // Method untuk mengambil produk berdasarkan ID
 public function show($id)
 {
     try {
         // Validasi ID produk (harus berupa angka positif)
         if (!is_numeric($id) || $id <= 0) {
             return response()->json([
                 'status' => 'error',
                 'message' => 'ID produk tidak valid.'
             ], 400);
         }

         // Mencari produk berdasarkan ID dengan relasi kategori
         $product = Product::with('category')->findOrFail($id);

         return response()->json([
             'status' => 'success',
             'message' => 'Produk berhasil ditemukan.',
             'data' => $product
         ], 200);
     } catch (ModelNotFoundException $e) {
         return response()->json([
             'status' => 'error',
             'message' => 'Produk tidak ditemukan',
             'error' => $e->getMessage() // Menambahkan pesan error untuk debug
         ], 404);
     } catch (\Exception $e) {
         return response()->json([
             'status' => 'error',
             'message' => 'Terjadi kesalahan saat mengambil data produk.',
             'error' => $e->getMessage() // Menambahkan pesan error untuk debug
         ], 500);
     }
 }
}

