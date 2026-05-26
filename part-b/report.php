<?php

// report.php
// Запуск: php report.php

class ReportApp
{
    private array $orders;          // всі замовлення
    private string $file;           // шлях до файлу звіту
    private array $validOrders;     // відфільтровані замовлення
    private string $logFile = 'report.log';

    public function __construct(array $orders, string $file)
    {
        $this->orders = $orders;
        $this->file = $file;
        $this->validOrders = [];

        $this->log("ReportApp запущено. Файл звіту: {$this->file}");
    }

    // Фільтрація замовлень: тільки status=paid і amount > 0
    public function process(): void
    {
        foreach ($this->orders as $order) {
            if ($order['status'] === 'paid' && $order['amount'] > 0) {
                $this->validOrders[] = $order;
            } else {
                // логування помилкових замовлень
                $reason = $order['status'] !== 'paid'
                    ? "status={$order['status']}"
                    : "amount={$order['amount']}";
                $this->log("Пропущено замовлення id={$order['id']}: {$reason}");
            }
        }

        $this->log("Валідних замовлень: " . count($this->validOrders));
    }

    // Рахуємо статистику і повертаємо масив
    public function summary(): array
    {
        $count = count($this->validOrders);
        $total = array_sum(array_column($this->validOrders, 'amount'));
        $avg = $count > 0 ? round($total / $count) : 0;

        return [
            'count' => $count,
            'total' => $total,
            'avg'   => $avg,
        ];
    }

    // Запис результату у файл
    public function write(): void
    {
        $s = $this->summary();

        $content = "Valid orders: {$s['count']}"    . PHP_EOL;
        $content .= "Total paid: {$s['total']}"     . PHP_EOL;
        $content .= "Avg amount: {$s['avg']}"       . PHP_EOL;

        // file_put_contents повертає false якщо не зміг записати
        $result = file_put_contents($this->file, $content, LOCK_EX);

        if ($result === false) {
            $this->log("ПОМИЛКА: не вдалося записати файл {$this->file}");
            echo "Помилка запису файлу!" . PHP_EOL;
        } else {
            $this->log("Файл успішно записано: {$this->file}");
            echo "File: {$this->file}" . PHP_EOL;
        }
    }

    // Запис рядку у лог файл з часом
    private function log(string $message): void
    {
        $time = date('Y-m-d H:i:s');

        try {
            $result = file_put_contents(
                $this->logFile,
                "[{$time}] {$message}" . PHP_EOL,
                FILE_APPEND | LOCK_EX
            );

            if ($result === false) {
                echo "[LOG ERROR] Не вдалося записати лог." . PHP_EOL;
            }
        } catch (\Exception $e) {
            echo "[LOG ERROR] {$e->getMessage()}" . PHP_EOL;
        }
    }

    // Викликається автоматично коли скрипт завершується
    public function __destruct()
    {
        $this->log("ReportApp завершено.");
        $this->log("---");
    }
}

// ─── Запуск ───────────────────────────────────────

$orders = [
    ["id" => 1, "user" => "Ivan",   "amount" => 100,  "status" => "paid"],
    ["id" => 2, "user" => "Oksana", "amount" => -50,  "status" => "paid"],
    ["id" => 3, "user" => "Ivan",   "amount" => 200,  "status" => "pending"],
    ["id" => 4, "user" => "Petro",  "amount" => 300,  "status" => "paid"],
    ["id" => 5, "user" => "Oleh",  "amount" => 1200,  "status" => "paid"],
    ["id" => 6, "user" => "Iryna",  "amount" => -100,  "status" => "paid"],
    ["id" => 7, "user" => "Olexandr",  "amount" => 5000,  "status" => "paid"],
    ["id" => 8, "user" => "Andriy",  "amount" => 2000,  "status" => "pending"]
];

echo "Start report" . PHP_EOL;

$app = new ReportApp($orders, "report.txt");
$app->process();

$summary = $app->summary();
echo "Valid orders: {$summary['count']}" . PHP_EOL;
echo "Total paid: {$summary['total']}"   . PHP_EOL;
echo "Avg amount: {$summary['avg']}"     . PHP_EOL;

$app->write();