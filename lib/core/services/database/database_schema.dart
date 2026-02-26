class DatabaseSchema {
  // TABLE NAMES
  static const String categoriesTable = 'categories';
  static const String transactionsTable = 'transactions';

  // COMMON COLUMNS
  static const String id = 'id';
  static const String isSynced = 'is_synced';
  static const String isDeleted = 'is_deleted';

  // CATEGORY COLUMNS
  static const String categoryName = 'name';

  // TRANSACTION COLUMNS
  static const String amount = 'amount';
  static const String note = 'note';
  static const String type = 'type'; // credit | debit
  static const String categoryId = 'category_id';
  static const String timestamp = 'timestamp';

  // CREATE TABLE: CATEGORIES
  static const String createCategoriesTable =
      '''
  CREATE TABLE $categoriesTable (
    $id TEXT PRIMARY KEY,
    $categoryName TEXT NOT NULL,
    $isSynced INTEGER NOT NULL DEFAULT 0,
    $isDeleted INTEGER NOT NULL DEFAULT 0
  );
  ''';

  // CREATE TABLE: TRANSACTIONS
  static const String createTransactionsTable =
      '''
  CREATE TABLE $transactionsTable (
    $id TEXT PRIMARY KEY,
    $amount REAL NOT NULL,
    $note TEXT,
    $type TEXT CHECK($type IN ('credit','debit')) NOT NULL,
    $categoryId TEXT NOT NULL,
    $timestamp TEXT NOT NULL,
    $isSynced INTEGER NOT NULL DEFAULT 0,
    $isDeleted INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY ($categoryId)
      REFERENCES $categoriesTable($id)
      ON DELETE RESTRICT
  );
  ''';

  // INDEXES
  static const String transactionCategoryIndex =
      '''
  CREATE INDEX idx_transactions_category
  ON $transactionsTable($categoryId);
  ''';

  static const String transactionDeletedIndex =
      '''
  CREATE INDEX idx_transactions_deleted
  ON $transactionsTable($isDeleted);
  ''';
}
