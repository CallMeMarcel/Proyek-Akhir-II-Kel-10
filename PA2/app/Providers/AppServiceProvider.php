<?php

namespace App\Providers;

use Illuminate\Support\Facades\Vite;
use Illuminate\Support\ServiceProvider;
use Illuminate\Database\Eloquent\Model;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        // Pastikan Laravel tidak melakukan lazy loading yang tidak disengaja
        Model::preventLazyLoading(!app()->isProduction());

        // Konfigurasi Vite agar menggunakan folder build default
        Vite::useBuildDirectory('/build');
    }
}
