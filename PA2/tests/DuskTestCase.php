<?php

namespace Tests;

use Facebook\WebDriver\Chrome\ChromeOptions;
use Facebook\WebDriver\Remote\DesiredCapabilities;
use Facebook\WebDriver\Remote\RemoteWebDriver;
use Illuminate\Support\Collection;
use Laravel\Dusk\TestCase as BaseTestCase;
use PHPUnit\Framework\Attributes\BeforeClass;

abstract class DuskTestCase extends BaseTestCase
{
    /**
     * The base URL to use while testing the application.
     *
     * @var string
     */
    protected static string $baseUrl = 'http://127.0.0.1:8000';

    /**
     * Prepare for Dusk test execution.
     */
    #[BeforeClass]
    public static function prepare(): void
    {
        if (!static::runningInSail()) {
            static::startChromeDriver();
        }
    }

    /**
     * Get the base URL for the application under test.
     *
     * @return string
     */
    protected function baseUrl(): string
    {
        return static::$baseUrl;
    }

    /**
     * Create the RemoteWebDriver instance.
     *
     * @return \Facebook\WebDriver\Remote\RemoteWebDriver
     */
    protected function driver(): RemoteWebDriver
    {
        $options = (new ChromeOptions)->addArguments(
            collect([
                $this->shouldStartMaximized() ? '--start-maximized' : '--window-size=1920,1080',
                '--disable-search-engine-choice-screen',
                '--disable-smooth-scrolling',
            ])
            ->unless($this->hasHeadlessDisabled(), function (Collection $items) {
                return $items->merge([
                    '--disable-gpu',
                    '--headless=new',
                ]);
            })
            ->all()
        );

        return RemoteWebDriver::create(
            $_ENV['DUSK_DRIVER_URL'] ?? env('DUSK_DRIVER_URL', 'http://localhost:9515'),
            DesiredCapabilities::chrome()->setCapability(
                ChromeOptions::CAPABILITY,
                $options
            )
        );
    }
}