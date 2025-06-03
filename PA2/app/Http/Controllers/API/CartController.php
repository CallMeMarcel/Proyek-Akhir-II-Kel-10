<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Cart;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;


class CartController extends Controller
{
    public function index(Request $request)
    {
        $carts = Cart::with('product')
                    ->where('user_id', $request->user()->id)
                    ->get();

        return response()->json($carts);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'product_id' => 'required|exists:products,id',
            'quantity' => 'required|integer|min:1',
        ]);

        $cart = Cart::updateOrCreate(
            [
                'user_id' => $request->user()->id,
                'product_id' => $validated['product_id'],
            ],
            [
                'quantity' => DB::raw('quantity + ' . $validated['quantity']),
            ]
        );

        return response()->json($cart, 201);
    }

    public function update(Request $request, $id)
    {
        $cart = Cart::where('id', $id)
                    ->where('user_id', $request->user()->id)
                    ->firstOrFail();

        $request->validate([
            'quantity' => 'required|integer|min:1',
        ]);

        $cart->update(['quantity' => $request->quantity]);

        return response()->json($cart);
    }

    public function destroy(Request $request, $id)
    {
        $cart = Cart::where('id', $id)
                    ->where('user_id', $request->user()->id)
                    ->firstOrFail();

        $cart->delete();

        return response()->json(['message' => 'Item removed from cart']);
    }
}
