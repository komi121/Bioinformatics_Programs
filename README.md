# Bioinformatics_Programs

# Docker-образ

Данный Docker-образ содержит набор специализированных биоинформатических инструментов для анализа данных секвенирования.

## Содержимое образа

### Специализированные программы:

1. **BWA-MEM2 v2.2.1**
   - Инструмента для выравнивания последовательностей ДНК
   - Расположение: `/tools/bwa-mem2-2.2.1/`
   - Исполняемый файл: `$BWAMEM2`

2. **SAMtools v1.21**
   - Набор утилит для работы с SAM/BAM/CRAM файлами
   - Расположение: `/tools/samtools-1.21/`
   - Исполняемый файл: `$SAMTOOLS`

3. **Picard v3.3.0**
   - Набор инструментов Java для работы с данными секвенирования в форматах SAM, BAM и VCF.
   - Расположение: `/tools/picard-3.3.0/`
   - Исполняемый файл: `$PICARD`

4. **MultiQC v1.27.1**
   - Инструмент для объединения результатов биоинформатического анализа в единый отчет
   - Исполняемый файл: `$MULTIQC`

## Команды для работы с Docker-образом

### Сборка образа
```bash
docker build -t bioinfo-tools:latest https://github.com/komi121/Bioinformatics_Programs.git
```

### Запуск в интерактивном режиме
```bash
docker run -it --rm -v /path/to/arkom/data:/data bioinfo-tools:latest
```

### Проверка установки
```bash
# Вывод справки samtools
samtools --help

# Проверка версии samtools
$SAMTOOLS --version

```
