import 'package:dio/dio.dart';

import 'models/transaction.dart';

const transactionsUrl =
    'https://mockend.com/rudarabello/flutter_dio_challenge/transactions';

abstract class TransactionRepository {
  Future<bool> createTransaction(Transaction transaction);
  Future<Transaction?> getTransactionData(int id);
  Future<bool> editTransactionData(Transaction transaction);
  Future<bool> deleteTransaction(int id);
}

class TransactionDioRepository implements TransactionRepository {
  final _dio = Dio();

  @override
  Future<bool> createTransaction(Transaction transaction) async {
    final response =
        await _dio.post(transactionsUrl, data: transaction.toMap());
    return response.statusCode == 201;
  }

  @override
  Future<bool> deleteTransaction(int id) async {
    final response = await _dio.delete('$transactionsUrl/$id');
    return response.statusCode == 204;
  }

  @override
  Future<bool> editTransactionData(Transaction transaction) async {
    final response = await _dio.put('$transactionsUrl/${transaction.id}',
        data: transaction.toMap());
    return response.statusCode == 200;
  }

  @override
  Future<Transaction?> getTransactionData(int id) async {
    final response = await _dio.get('$transactionsUrl/$id');
    if (response.statusCode == 200) {
      return Transaction.fromMap(response.data);
    }
    return null;
  }
}
