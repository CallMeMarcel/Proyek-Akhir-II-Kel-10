<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Order;
use Illuminate\Http\Request;

class OrderApiController extends Controller
{
    public function index()
    {
        $orders = Order::with(['user', 'items.product'])
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'status' => 'success',
            'data' => $orders,
        ], 200);
    }

    public function show($id)
    {
        $order = Order::with(['user', 'items.product'])->findOrFail($id);

        return response()->json([
            'status' => 'success',
            'data' => $order,
        ], 200);
    }
}