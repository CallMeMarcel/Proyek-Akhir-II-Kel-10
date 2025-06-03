<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Product;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Facades\DB;

class ManualOrderController extends Controller
{
    public function create()
    {
        return Inertia::render('Admin/Order/Create', [
            'products' => Product::where('status', 'available')->get(),
        ]);
    }

    public function store(Request $request)
{
    $validated = $request->validate([
        'items'            => 'required|array|min:1',
        'items.*.product_id' => 'required|exists:products,id',
        'items.*.quantity'   => 'required|integer|min:1',
    ]);

    DB::transaction(function () use ($validated) {
        // Ganti user_id sesuai kebutuhan, contoh auth()->id()
        $order = Order::create([
            'user_id'        => auth()->id(),  // wajib diisi
            'order_number'   => 'ORD-' . strtoupper(uniqid()),
            'status'         => 'completed',
            'payment_status' => 'unpaid',
            'total_price'    => 0,
        ]);

        $total = 0;
        foreach ($validated['items'] as $item) {
            $product  = Product::findOrFail($item['product_id']);
            $subtotal = $product->price * $item['quantity'];

            OrderItem::create([
                'order_id'   => $order->id,
                'product_id' => $product->id,
                'quantity'   => $item['quantity'],
                'price' => $product->price,
                'subtotal'   => $subtotal,
            ]);

            $total += $subtotal;
        }

        $order->update(['total_price' => $total]);
    });

    return redirect()
        ->route('admin.orders.index')
        ->with('success', 'Order berhasil dibuat');
}
}