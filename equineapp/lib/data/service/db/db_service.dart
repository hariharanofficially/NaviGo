import '../../models/transaction.dart';

abstract class DbService {
  Future<void> open();
  Future<void> close();
  Future<void> initialize();
  Future<Transaction> insert(Transaction transaction);
  Future<int> delete(int id);
  Future<List<Transaction>> get(int limit);
}