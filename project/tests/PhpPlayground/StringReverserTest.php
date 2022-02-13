<?php declare(strict_types=1);

namespace PhpPlayground;

use PHPUnit\Framework\TestCase;

class StringReverserTest extends TestCase
{

    private StringReverser $instance;

    public function setUp(): void
    {
        $this->instance = new StringReverser();
    }

    /**
     * @dataProvider randomStringsProvider
     */
    public function testDoesReverseString(string $string, string $expected): void
    {
        $this->assertSame(
            $expected,
            $this->instance->reverse($string),
            "Did not reverse string connectly");
    }

    public function randomStringsProvider(): array
    {
        return [
            ['thisisarandomstring', strrev('thisisarandomstring')],
            ['a', 'a'],
            ['', '']
        ];
    }
}
