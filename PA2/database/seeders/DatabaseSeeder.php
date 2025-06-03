<?php

namespace Database\Seeders;

use App\Models\User;
// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;
class DatabaseSeeder extends Seeder
{
    
    public function run(): void
     {
        DB::table('users')->insert([
            'name' => 'Admin',
            'email' => 'admindelcafe@gmail.com',
            'password' => Hash::make('Admin123'), // Ganti dengan password yang kuat
            'role' => 'admin',
            'phone' => '+6282273243039',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }   
}