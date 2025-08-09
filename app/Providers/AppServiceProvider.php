<?php

namespace App\Providers;

use Illuminate\Support\Facades\URL; // Make sure this line is present
use Illuminate\Support\ServiceProvider;

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
        // Add this if-statement to the boot method
        if (config('app.env') === 'production') {
            URL::forceScheme('https');
        }
    }
}