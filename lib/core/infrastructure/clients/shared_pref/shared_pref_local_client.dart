import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable()
class SharedPrefLocalClient {
  SharedPrefLocalClient(this.instance);

  final SharedPreferences instance;

  @FactoryMethod(preResolve: true)
  static Future<SharedPrefLocalClient> create() async {
    final instance = await SharedPreferences.getInstance();
    return SharedPrefLocalClient(instance);
  }
}
