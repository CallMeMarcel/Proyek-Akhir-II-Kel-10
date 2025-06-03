<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('order_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('order_id')->constrained()->onDelete('cascade'); // 👈 tambahkan ini
            $table->foreignId('product_id')->constrained()->onDelete('restrict');
            $table->integer('quantity');
            $table->decimal('unit_price', 15, 2);
            $table->decimal('price', 10, 2);
            $table->decimal('subtotal', 15, 2);
            $table->timestamps();
        });
        
    }

    public function down(): void
{
    Schema::table('order_items', function (Blueprint $table) {
        $table->dropForeign(['order_id']);
        $table->dropForeign(['product_id']);
    });

    Schema::dropIfExists('order_items');
}
};