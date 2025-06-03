<?php

namespace Tests\Browser;

use Laravel\Dusk\Browser;
use Tests\DuskTestCase;
use Illuminate\Foundation\Testing\DatabaseMigrations;
use App\Models\User;

class LoginTest extends DuskTestCase
{
    use DatabaseMigrations;

    public function test_admin_can_login()
    {
        // Buat user admin dummy
        $user = User::factory()->create([
            'email'    => 'admin@example.com',
            'password' => bcrypt('password123'),
        ]);

        $this->browse(function (Browser $browser) {
            $$browser->visit('/login')
            ->waitFor('#email', 10)
            ->type('#email', 'admin@example.com')
            ->type('#password', 'password123')
            ->press('Log in')
            ->assertPathIs('/dashboard');
        });
    }
}
