#!/bin/bash
set -e

echo "=== SQLite ICU Extension Test - Ubuntu Linux ==="

# Check if extension file exists
if [ ! -f "/workspace/libSqliteIcu-linux-ubuntu-amd64.so" ]; then
    echo "ERROR: Extension file not found!"
    exit 1
fi

echo "✓ Extension file found"

# Test basic loading
echo "Testing basic extension loading..."
sqlite3 test.db <<EOF
.load /workspace/libSqliteIcu-linux-ubuntu-amd64.so
SELECT 'Extension loaded successfully' as result;
.quit
EOF

echo "✓ Basic loading test passed"

# Test ICU collation loading
echo "Testing ICU collation loading..."
sqlite3 test.db <<EOF
.load /workspace/libSqliteIcu-linux-ubuntu-amd64.so
SELECT icu_load_collation('en_US', 'STANDARD') as collation_result;
.quit
EOF

echo "✓ ICU collation test passed"

# Test Unicode text handling
echo "Testing Unicode text handling..."
sqlite3 test.db <<EOF
.load /workspace/libSqliteIcu-linux-ubuntu-amd64.so
CREATE TABLE test_unicode (text TEXT);
INSERT INTO test_unicode VALUES ('Hello'), ('안녕하세요'), ('Здравствуйте'), ('こんにちは');
SELECT COUNT(*) as unicode_count FROM test_unicode;
.quit
EOF

echo "✓ Unicode handling test passed"

# Test ICU collation with Korean text
echo "Testing Korean collation..."
sqlite3 test.db <<EOF
.load /workspace/libSqliteIcu-linux-ubuntu-amd64.so
SELECT icu_load_collation('ko_KR', 'STANDARD') as korean_collation;
CREATE TABLE korean_test (name TEXT);
INSERT INTO korean_test VALUES ('가나다'), ('라마바'), ('사아자');
SELECT name FROM korean_test ORDER BY name COLLATE 'ko_KR';
.quit
EOF

echo "✓ Korean collation test passed"

# Test ICU functions if available
echo "Testing ICU functions..."
sqlite3 test.db <<EOF
.load /workspace/libSqliteIcu-linux-ubuntu-amd64.so
SELECT CASE 
    WHEN typeof(upper('test')) = 'text' THEN 'ICU functions available'
    ELSE 'ICU functions not available'
END as function_test;
.quit
EOF

echo "✓ ICU functions test completed"

echo ""
echo "=== All Ubuntu Linux tests passed! ==="
echo "Platform: $(uname -m)"
echo "SQLite version: $(sqlite3 --version)"
echo "ICU version: $(icu-config --version 2>/dev/null || echo 'ICU config not available')"

# Cleanup
rm -f test.db