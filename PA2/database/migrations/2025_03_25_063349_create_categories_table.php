<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Jalankan migrasi untuk membuat tabel kategori.
     */
    public function up(): void
    {
        Schema::create('categories', function (Blueprint $table) {
            $table->id();
            $table->string('name')->unique();
            
            $table->unsignedBigInteger('user_id'); // Relasi ke user
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
            
            $table->timestamps();
        });
        
    }

    /**
     * Rollback migrasi jika diperlukan.
     */
    public function down(): void
    {
        Schema::dropIfExists('categories');
    }
};
