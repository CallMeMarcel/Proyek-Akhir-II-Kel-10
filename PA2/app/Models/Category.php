<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Category extends Model
{
    use HasFactory;

    protected $fillable = ['name', 'user_id'];

    // Relasi ke User (jika kategori milik user tertentu)
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    // Relasi ke produk (1 kategori bisa punya banyak produk)
    public function products()
    {
        return $this->hasMany(Product::class);
    }
}
