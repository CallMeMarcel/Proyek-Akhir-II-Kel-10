<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

class Product extends Model
{
    use HasFactory;

    protected $fillable = [
        'title',
        'image',
        'description',
        'status',
        'price',
        'category_id',
        'user_id', // jika produk dibuat oleh user tertentu
    ];

    protected $casts = [
        'price' => 'float',
    ];

    // Append attribute tambahan ke model JSON output
    protected $appends = ['image_url'];

    /**
     * Relasi ke kategori produk.
     */
    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    /**
     * Relasi ke user (opsional, jika ada creator produk).
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Akses custom: URL gambar produk.
     */
    public function getImageUrlAttribute()
    {
        return $this->image
            ? Storage::url($this->image)
            : asset('images/default.png');
    }
}
