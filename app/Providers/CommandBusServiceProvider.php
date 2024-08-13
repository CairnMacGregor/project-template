<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use League\Tactician\CommandBus;
use League\Tactician\Doctrine\ORM\TransactionMiddleware;
use Doctrine\ORM\EntityManagerInterface;

class CommandBusServiceProvider extends ServiceProvider
{
    public function register()
    {
        $this->app->singleton(CommandBus::class, function ($app) {
            $entityManager = $app->make(EntityManagerInterface::class);

            return new CommandBus([
                new TransactionMiddleware($entityManager),
            ]);
        });
    }
}
