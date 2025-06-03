<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Jalankan migrasi untuk membuat tabel produk.
     */
    public function up(): void
    {
        Schema::create('products', function (Blueprint $table) {
            $table->id();
            $table->string('image')->nullable();
            $table->string('title');
            $table->text('description');
            $table->enum('status', ['available', 'unavailable'])->default('available');
            $table->decimal('price', 10, 2);
            
            $table->unsignedBigInteger('category_id');
            $table->foreign('category_id')->references('id')->on('categories')->onDelete('cascade');
            
            $table->unsignedBigInteger('user_id'); // Tambahan ini
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
            
            $table->timestamps();
        });
        
        
    }

    /**
     * Rollback migrasi jika diperlukan.
     */
    public function down(): void
    {
        Schema::dropIfExists('products');
    }
};
