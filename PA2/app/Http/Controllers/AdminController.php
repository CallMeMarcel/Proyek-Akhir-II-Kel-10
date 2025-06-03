<?php

namespace App\Http\Controllers;

use App\Models\Category;
use App\Models\Product;
use App\Models\Order;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class AdminController extends Controller
{
    public function dashboard()
    {
        $stats = [
            'kategori' => Category::count(),
            'produk' => Product::count(),
            'orders' => Order::count(),
            'revenue_by_date' => Order::where('status', 'selesai')
                ->select(DB::raw("DATE(created_at) as date"), DB::raw("SUM(total_price) as total"))
                ->groupBy(DB::raw("DATE(created_at)"))
                ->orderBy('date', 'asc')
                ->get(),
        ];

        return Inertia::render('Admin/Dashboard', [
            'stats' => $stats
        ]);
    }

    public function kategori()
    {
        return Inertia::render('Admin/Kategori');
    }

    public function produk()
    {
        return Inertia::render('Admin/Produk');
    }
}
