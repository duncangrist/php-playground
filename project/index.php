<?php

namespace PhpPlayground;

require __DIR__ . '/vendor/autoload.php';

$instance = new StringReverser();
echo $instance->reverse("thstring");
