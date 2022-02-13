<?php

namespace PhpPlayground;

class StringReverser
{
    public function reverse(string $theString): string
    {
        return strrev($theString);
    }
}