import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/hashes/logic/hashes.dart';

class _DefaultHash extends StatefulWidget {
  final Function hashFunction;
  final bool keyRequired;

  const _DefaultHash({Key? key, required this.hashFunction, this.keyRequired = false}) : super(key: key);

  @override
  _DefaultHashState createState() => _DefaultHashState();
}

class _DefaultHashState extends State<_DefaultHash> {
  String _currentValue = '';
  String _currentKey = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          onChanged: (value) {
            setState(() {
              _currentValue = value;
            });
          },
        ),
        widget.keyRequired
            ? GCWTextField(
                hintText: i18n(context, 'common_key'),
                onChanged: (value) {
                  setState(() {
                    _currentKey = value;
                  });
                },
              )
            : Container(),
        widget.keyRequired
            ? GCWDefaultOutput(child: widget.hashFunction(_currentValue, _currentKey))
            : GCWDefaultOutput(child: widget.hashFunction(_currentValue))
      ],
    );
  }
}

class BLAKE2b_160 extends _DefaultHash {
  const BLAKE2b_160({Key? key}) : super(key: key, hashFunction: blake2b_160Digest);
}

class BLAKE2b_224 extends _DefaultHash {
  const BLAKE2b_224({Key? key}) : super(key: key, hashFunction: blake2b_224Digest);
}

class BLAKE2b_256 extends _DefaultHash {
  const BLAKE2b_256({Key? key}) : super(key: key, hashFunction: blake2b_256Digest);
}

class BLAKE2b_384 extends _DefaultHash {
  const BLAKE2b_384({Key? key}) : super(key: key, hashFunction: blake2b_384Digest);
}

class BLAKE2b_512 extends _DefaultHash {
  const BLAKE2b_512({Key? key}) : super(key: key, hashFunction: blake2b_512Digest);
}

class MD2 extends _DefaultHash {
  const MD2({Key? key}) : super(key: key, hashFunction: md2Digest);
}

class MD4 extends _DefaultHash {
  const MD4({Key? key}) : super(key: key, hashFunction: md4Digest);
}

class MD5 extends _DefaultHash {
  const MD5({Key? key}) : super(key: key, hashFunction: md5Digest);
}

class RIPEMD_128 extends _DefaultHash {
  const RIPEMD_128({Key? key}) : super(key: key, hashFunction: ripemd_128Digest);
}

class RIPEMD_160 extends _DefaultHash {
  const RIPEMD_160({Key? key}) : super(key: key, hashFunction: ripemd_160Digest);
}

class RIPEMD_256 extends _DefaultHash {
  const RIPEMD_256({Key? key}) : super(key: key, hashFunction: ripemd_256Digest);
}

class RIPEMD_320 extends _DefaultHash {
  const RIPEMD_320({Key? key}) : super(key: key, hashFunction: ripemd_320Digest);
}

class SHA1 extends _DefaultHash {
  const SHA1({Key? key}) : super(key: key, hashFunction: sha1Digest);
}

class SHA224 extends _DefaultHash {
  const SHA224({Key? key}) : super(key: key, hashFunction: sha224Digest);
}

class SHA256 extends _DefaultHash {
  const SHA256({Key? key}) : super(key: key, hashFunction: sha256Digest);
}

class SHA384 extends _DefaultHash {
  const SHA384({Key? key}) : super(key: key, hashFunction: sha384Digest);
}

class SHA512 extends _DefaultHash {
  const SHA512({Key? key}) : super(key: key, hashFunction: sha512Digest);
}

class SHA512_224 extends _DefaultHash {
  const SHA512_224({Key? key}) : super(key: key, hashFunction: sha512_224Digest);
}

class SHA512_256 extends _DefaultHash {
  const SHA512_256({Key? key}) : super(key: key, hashFunction: sha512_256Digest);
}

class SHA3_224 extends _DefaultHash {
  const SHA3_224({Key? key}) : super(key: key, hashFunction: sha3_224Digest);
}

class SHA3_256 extends _DefaultHash {
  const SHA3_256({Key? key}) : super(key: key, hashFunction: sha3_256Digest);
}

class SHA3_384 extends _DefaultHash {
  const SHA3_384({Key? key}) : super(key: key, hashFunction: sha3_384Digest);
}

class SHA3_512 extends _DefaultHash {
  const SHA3_512({Key? key}) : super(key: key, hashFunction: sha3_512Digest);
}

class Keccak_128 extends _DefaultHash {
  const Keccak_128({Key? key}) : super(key: key, hashFunction: keccak_128Digest);
}

class Keccak_224 extends _DefaultHash {
  const Keccak_224({Key? key}) : super(key: key, hashFunction: keccak_224Digest);
}

class Keccak_256 extends _DefaultHash {
  const Keccak_256({Key? key}) : super(key: key, hashFunction: keccak_256Digest);
}

class Keccak_288 extends _DefaultHash {
  const Keccak_288({Key? key}) : super(key: key, hashFunction: keccak_288Digest);
}

class Keccak_384 extends _DefaultHash {
  const Keccak_384({Key? key}) : super(key: key, hashFunction: keccak_384Digest);
}

class Keccak_512 extends _DefaultHash {
  const Keccak_512({Key? key}) : super(key: key, hashFunction: keccak_512Digest);
}

class Tiger_192 extends _DefaultHash {
  const Tiger_192({Key? key}) : super(key: key, hashFunction: tiger_192Digest);
}

class Whirlpool_512 extends _DefaultHash {
  const Whirlpool_512({Key? key}) : super(key: key, hashFunction: whirlpool_512Digest);
}

class SHA1HMac extends _DefaultHash {
  const SHA1HMac({Key? key}) : super(key: key, hashFunction: sha1Hmac, keyRequired: true);
}

class SHA224HMac extends _DefaultHash {
  const SHA224HMac({Key? key}) : super(key: key, hashFunction: sha224Hmac, keyRequired: true);
}

class SHA256HMac extends _DefaultHash {
  const SHA256HMac({Key? key}) : super(key: key, hashFunction: sha256Hmac, keyRequired: true);
}

class SHA384HMac extends _DefaultHash {
  const SHA384HMac({Key? key}) : super(key: key, hashFunction: sha384Hmac, keyRequired: true);
}

class SHA512HMac extends _DefaultHash {
  const SHA512HMac({Key? key}) : super(key: key, hashFunction: sha512Hmac, keyRequired: true);
}

class SHA512_224HMac extends _DefaultHash {
  const SHA512_224HMac({Key? key}) : super(key: key, hashFunction: sha512_224Hmac, keyRequired: true);
}

class SHA512_256HMac extends _DefaultHash {
  const SHA512_256HMac({Key? key}) : super(key: key, hashFunction: sha512_256Hmac, keyRequired: true);
}

class SHA3_224HMac extends _DefaultHash {
  const SHA3_224HMac({Key? key}) : super(key: key, hashFunction: sha3_224Hmac, keyRequired: true);
}

class SHA3_256HMac extends _DefaultHash {
  const SHA3_256HMac({Key? key}) : super(key: key, hashFunction: sha3_256Hmac, keyRequired: true);
}

class SHA3_384HMac extends _DefaultHash {
  const SHA3_384HMac({Key? key}) : super(key: key, hashFunction: sha3_384Hmac, keyRequired: true);
}

class SHA3_512HMac extends _DefaultHash {
  const SHA3_512HMac({Key? key}) : super(key: key, hashFunction: sha3_512Hmac, keyRequired: true);
}

class MD2HMac extends _DefaultHash {
  const MD2HMac({Key? key}) : super(key: key, hashFunction: md2Hmac, keyRequired: true);
}

class MD4HMac extends _DefaultHash {
  const MD4HMac({Key? key}) : super(key: key, hashFunction: md4Hmac, keyRequired: true);
}

class MD5HMac extends _DefaultHash {
  const MD5HMac({Key? key}) : super(key: key, hashFunction: md5Hmac, keyRequired: true);
}

class RIPEMD_128HMac extends _DefaultHash {
  const RIPEMD_128HMac({Key? key}) : super(key: key, hashFunction: ripemd_128Hmac, keyRequired: true);
}

class RIPEMD_160HMac extends _DefaultHash {
  const RIPEMD_160HMac({Key? key}) : super(key: key, hashFunction: ripemd_128Hmac, keyRequired: true);
}

class RIPEMD_256HMac extends _DefaultHash {
  const RIPEMD_256HMac({Key? key}) : super(key: key, hashFunction: ripemd_256Hmac, keyRequired: true);
}

class RIPEMD_320HMac extends _DefaultHash {
  const RIPEMD_320HMac({Key? key}) : super(key: key, hashFunction: ripemd_320Hmac, keyRequired: true);
}

class Tiger_192HMac extends _DefaultHash {
  const Tiger_192HMac({Key? key}) : super(key: key, hashFunction: tiger_192Hmac, keyRequired: true);
}

class Whirlpool_512HMac extends _DefaultHash {
  const Whirlpool_512HMac({Key? key}) : super(key: key, hashFunction: whirlpool_512Hmac, keyRequired: true);
}
