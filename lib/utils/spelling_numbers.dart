// MIT License

// Copyright (c) 2022 Mohammad Attar

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

library spelling_number;

import 'dart:math' as math;

class SpellingNumber {
  bool? noAnd;
  String? alternativeBase;
  String? decimalSeperator;
  String? wholesUnit;
  String? fractionUnit;
  int? digitsLengthW2F;
  String? lang;

  final Map<String, dynamic> _spellingNumberDefault = {
    "noAnd": false,
    "alternativeBase": null,
    "decimalSeperator": '',
    "wholesUnit": '',
    "fractionUnit": '',
    "digitsLengthW2F": null,
    "lang": "fr",
    "i18n": {
      'fr': {
        "useLongScale": false,
        "baseSeparator": "-",
        "unitSeparator": "",
        "base": {
          "0": "zéro",
          "1": "un",
          "2": "deux",
          "3": "trois",
          "4": "quatre",
          "5": "cinq",
          "6": "six",
          "7": "sept",
          "8": "huit",
          "9": "neuf",
          "10": "dix",
          "11": "onze",
          "12": "douze",
          "13": "treize",
          "14": "quatorze",
          "15": "quinze",
          "16": "seize",
          "17": "dix-sept",
          "18": "dix-huit",
          "19": "dix-neuf",
          "20": "vingt",
          "30": "trente",
          "40": "quarante",
          "50": "cinquante",
          "60": "soixante",
          "70": "soixante-dix",
          "80": "quatre-vingt",
          "90": "quatre-vingt-dix"
        },
        "units": [
          {
            "singular": "cent",
            "plural": "cents",
            "avoidInNumberPlural": true,
            "avoidPrefixException": [1]
          },
          {
            "singular": "mille",
            "avoidPrefixException": [1]
          },
          {"singular": "million", "plural": "millions"},
          {"singular": "milliard", "plural": "milliards"},
          {"singular": "billion", "plural": "billions"},
          {"singular": "billiard", "plural": "billiards"},
          {"singular": "trillion", "plural": "trillions"},
          {"singular": "trilliard", "plural": "trilliards"},
          {"singular": "quadrillion", "plural": "quadrillions"},
          {"singular": "quadrilliard", "plural": "quadrilliards"},
          {"singular": "quintillion", "plural": "quintillions"},
          {"singular": "quintilliard", "plural": "quintilliards"},
          {"singular": "sextillion", "plural": "sextillions"},
          {"singular": "sextilliard", "plural": "sextilliards"},
          {"singular": "septillion", "plural": "septillions"},
          {"singular": "septilliard", "plural": "septilliards"},
          {"singular": "octillion", "plural": "octillions"}
        ],
        "unitExceptions": {
          21: "vingt et un",
          31: "trente et un",
          41: "quarante et un",
          51: "cinquante et un",
          61: "soixante et un",
          71: "soixante et onze",
          72: "soixante-douze",
          73: "soixante-treize",
          74: "soixante-quatorze",
          75: "soixante-quinze",
          76: "soixante-seize",
          77: "soixante-dix-sept",
          78: "soixante-dix-huit",
          79: "soixante-dix-neuf",
          80: "quatre-vingts",
          91: "quatre-vingt-onze",
          92: "quatre-vingt-douze",
          93: "quatre-vingt-treize",
          94: "quatre-vingt-quatorze",
          95: "quatre-vingt-quinze",
          96: "quatre-vingt-seize",
          97: "quatre-vingt-dix-sept",
          98: "quatre-vingt-dix-huit",
          99: "quatre-vingt-dix-neuf"
        }
      },
    }
  };

  SpellingNumber(
      {this.noAnd,
      this.alternativeBase,
      this.decimalSeperator,
      this.wholesUnit,
      this.fractionUnit,
      this.digitsLengthW2F,
      this.lang}) {
    _spellingNumberDefault["noAnd"] = noAnd ?? _spellingNumberDefault["noAnd"];
    _spellingNumberDefault["alternativeBase"] =
        alternativeBase ?? _spellingNumberDefault["alternativeBase"];
    _spellingNumberDefault["decimalSeperator"] =
        decimalSeperator ?? _spellingNumberDefault["decimalSeperator"];
    _spellingNumberDefault["wholesUnit"] =
        wholesUnit ?? _spellingNumberDefault["wholesUnit"];
    _spellingNumberDefault["fractionUnit"] =
        fractionUnit ?? _spellingNumberDefault["fractionUnit"];
    _spellingNumberDefault["digitsLengthW2F"] =
        digitsLengthW2F ?? _spellingNumberDefault["digitsLengthW2F"];
    _spellingNumberDefault["lang"] = lang ?? _spellingNumberDefault["lang"];
  }

  // Converts numbers to their written form.

  // @param {Number} n The number to convert
  // @return {String} writtenN The written form of `n`

  String _spellingNumber(num n, Map<String, dynamic> language,
      List<num> longScale, List<num> shortScale) {
    if (n < 0) {
      return "";
    }

    n = n.round();

    List scale = language['useLongScale'] ? longScale : shortScale;
    var units = language['units'];
    var unit;

    if ((units is! List)) {
      Map<dynamic, dynamic> rawUnits = units;

      units = [];
      scale = rawUnits.keys.toList();
      List<int> _scale = [];

      for (int i = 0; i < scale.length; i++) {
        units.add(rawUnits[scale[i]]);
        _scale.add(math.pow(10, int.parse(scale[i])) as int);
      }
      scale = _scale;
    }

    var baseCardinals = language['base'];

    var alternativeBaseCardinals = _spellingNumberDefault['alternativeBase'] !=
            null
        ? language['alternativeBase'][_spellingNumberDefault['alternativeBase']]
        : {};
    print("language: ${language['unitExceptions'][21]}\n");
    if (language['unitExceptions'] != null &&
        language['unitExceptions'].length > 0 &&
        language['unitExceptions'][n] != null) {
      return language['unitExceptions'][n];
    }

    if (alternativeBaseCardinals.length > 0 &&
        alternativeBaseCardinals[n] != null) {
      return alternativeBaseCardinals[n];
    }
    if (baseCardinals.length > 0 && baseCardinals[n.toString()] != null) {
      return baseCardinals[n.toString()];
    }

    if (n < 100) {
      return handleSmallerThan100(n, language, unit, baseCardinals,
          alternativeBaseCardinals, longScale, shortScale);
    }

    var m = n % 100;
    var ret = [];
    print("\n**** m: $m\n");
    if (m != 0) {
      if (_spellingNumberDefault['noAnd'] &&
          !(language['andException'] != null && language['andException'][10])) {
        ret.add(_spellingNumber(m, language, longScale, shortScale));
      } else {
        ret.add(language['unitSeparator'] +
            _spellingNumber(m, language, longScale, shortScale));
      }
    }
    print("\n**** ret: $ret\n");

    int firstSignificant = 0;

    for (var i = 0, len = units.length; i < len; i++) {
      int r = (n / scale[i]).floor();
      int divideBy;

      if (i == (len - 1)) {
        divideBy = 1000000;
      } else {
        divideBy =
            int.parse((scale[i + 1] / scale[i]).toString().split('.')[0]);
      }
      r %= divideBy;

      unit = units[i];

      if (r == 0) continue;
      firstSignificant = scale[i];

      if (unit is! String &&
          unit['useBaseInstead'] != null &&
          unit['useBaseInstead']) {
        var shouldUseBaseException = unit['useBaseException'].indexOf(r) > -1 &&
            (unit['useBaseExceptionWhenNoTrailingNumbers'] != null &&
                    unit['useBaseExceptionWhenNoTrailingNumbers']
                ? (i == 0 && ret.length > 0)
                : true);
        if (!shouldUseBaseException) {
          var k = (r * scale[i]).toString();
          var s = '-NULL-';
          if (alternativeBaseCardinals[k] != null) {
            s = alternativeBaseCardinals[k];
          }

          if (baseCardinals[k] != null) {
            s = baseCardinals[k];
          }
          ret.add(s);
        } else {
          ret.add(r > 1 && unit['plural'] != null
              ? unit['plural']
              : unit['singular']);
        }
        continue;
      }

      var str;
      if (unit is String) {
        str = unit;
      } else if (r == 1 ||
          unit['useSingularEnding'] != null &&
              unit['useSingularEnding'] &&
              r % 10 == 1 &&
              (unit['avoidEndingRules'] == null ||
                  unit['avoidEndingRules'].indexOf(r) < 0)) {
        str = unit['singular'];
      } else if (unit['few'] != null &&
          (r > 1 && r < 5 ||
              unit['useFewEnding'] != null &&
                  unit['useFewEnding'] &&
                  r % 10 > 1 &&
                  r % 10 < 5 &&
                  (unit['avoidEndingRules'] == null ||
                      unit['avoidEndingRules'].indexOf(r) < 0))) {
        str = unit['few'];
      } else {
        str = unit['plural'] != null &&
                ((unit['avoidInNumberPlural'] != null &&
                        !unit['avoidInNumberPlural']) ||
                    m == 0)
            ? unit['plural']
            : unit['singular'];

        // Languages with dual
        str = (r == 2 && unit['dual'] != null) ? unit['dual'] : str;

        // "restrictedPlural" : use plural only for 3 to 10
        str = (r > 10 &&
                unit['restrictedPlural'] != null &&
                unit['restrictedPlural'])
            ? unit['singular']
            : str;
      }

      if (unit is! String &&
          unit['avoidPrefixException'] != null &&
          unit['avoidPrefixException'].length > 0 &&
          unit['avoidPrefixException'].indexOf(r) > -1) {
        ret.add(str);
        continue;
      }

      print("\n**** r: $r\n");
      var exception = (language['unitExceptions'].length > 0 &&
              language['unitExceptions'][r] != null)
          ? language['unitExceptions'][r]
          : null;

      dynamic number;
      if (exception != null) {
        number = exception;
      } else {
        _spellingNumberDefault['noAnd'] = !((language['andException'] != null &&
                    language['andException'] &&
                    language['andException'][r] != null &&
                    language['andException'][r]) ||
                ((unit is! String) &&
                    unit.length > 0 &&
                    unit['andException'] != null &&
                    unit['andException'])) &&
            true;
        _spellingNumberDefault['alternativeBase'] = ((unit is! String) &&
                unit.length > 0 &&
                unit['useAlternativeBase'] != null)
            ? unit['useAlternativeBase']
            : null;

        number = _spellingNumber(r, language, longScale, shortScale);
      }

      n -= r * scale[i];
      ret.add(number + " " + str);
    }

    var firstSignificantN = firstSignificant * (n / firstSignificant).floor();
    var rest = n - firstSignificantN;

    if (language['andWhenTrailing'] != null &&
        language['andWhenTrailing'] &&
        firstSignificant > 0 &&
        0 < rest &&
        ret[0].indexOf(language['unitSeparator']) != 0) {
      ret = [ret[0], language['unitSeparator'].replaceAll(RegExp(r"\s+"), "")] +
          ret.sublist(1);
    }

    // Languages that have separators for all cardinals.
    if (language['allSeparator'] != null) {
      for (int j = 0; j < ret.length - 1; j++) {
        ret[j] = language['allSeparator'] + ret[j];
      }
    }
    var result = ret.reversed.toList().join(" ");
    return result;
  }

  // Throw error
  Error throwError(content) {
    throw Exception('spellingNumber: ' + content);
  }

  dynamic handleSmallerThan100(n, language, unit, baseCardinals,
      alternativeBaseCardinals, List<num> longScale, List<num> shortScale) {
    var dec = (n / 10).floor() * 10;
    unit = n - dec;
    String decS = dec.toString();

    if (unit > 0) {
      if (alternativeBaseCardinals != null &&
          alternativeBaseCardinals[decS] != null) {
        return alternativeBaseCardinals[decS];
      }
      if (baseCardinals != null && baseCardinals[decS] != null) {
        return (baseCardinals[decS] +
            language['baseSeparator'] +
            _spellingNumber(unit, language, longScale, shortScale));
      }
    }

    if (alternativeBaseCardinals != null &&
        alternativeBaseCardinals[decS] != null) {
      return alternativeBaseCardinals[decS];
    }

    if (baseCardinals != null && baseCardinals[decS] != null) {
      return baseCardinals[decS];
    }
  }

  bool _isNumeric(String? str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  String convert(num number) {
    var languages = [
      "en",
      "es",
      "ar",
      "enIndian",
      "ptPT",
      "hu",
      "pt",
      "fr",
      "eo",
      "it",
      "vi",
      "tr",
      "uk",
      "ru",
      "id"
    ];

    var shortScale = [
      100,
      1000,
      1000000,
      1000000000,
      1000000000000,
      1000000000000000,
      1000000000000000000,
      1e+21,
      1e+24,
      1e+27,
      1e+30,
      1e+33,
      9.999999999999999e+35,
      1.0000000000000001e+39,
      9.999999999999999e+41,
      1e+45,
      1e+48
    ];

    var longScale = [
      100,
      1000,
      1000000,
      1000000000000,
      1000000000000000000,
      1e+24,
      1e+30,
      9.999999999999999e+35,
      9.999999999999999e+41,
      1e+48,
      1e+54,
      1e+60,
      1e+66,
      1e+72,
      1e+78,
      1e+84,
      1e+90
    ];

    var language = (_spellingNumberDefault is String)
        ? _spellingNumberDefault['i18n'][_spellingNumberDefault['lang']]
        : _spellingNumberDefault['lang'];

    if (language != null) {
      if (!languages.contains(_spellingNumberDefault['lang'])) {
        _spellingNumberDefault['defaults']['lang'] = "en";
      }

      language = _spellingNumberDefault['i18n'][_spellingNumberDefault['lang']];
    }

    var wholesSpelling = '';
    var fractionSpelling = '';

    var b = number.toString().split(".");

    var wholes = b[0];
    wholesSpelling =
        _spellingNumber(double.parse(wholes), language, longScale, shortScale);

    if (b.length > 1 &&
        _isNumeric(_spellingNumberDefault['digitsLengthW2F'].toString())) {
      if (b[1].length < _spellingNumberDefault['digitsLengthW2F']) {
        int newDigitsNumber = int.parse(b[1]);
        int digitsToAdd =
            (_spellingNumberDefault['digitsLengthW2F'] as int) - b[1].length;
        newDigitsNumber *= digitsToAdd * 10;
        b[1] = newDigitsNumber.toString();
      }

      double fraction = double.parse("0." +
          (b[1].substring(0, _spellingNumberDefault['digitsLengthW2F'])));
      fraction = fraction *
          (math.pow(
              10,
              _spellingNumberDefault[
                  'digitsLengthW2F'])); //Convert to Fraction Unit
      if (fraction > 0) {
        fractionSpelling =
            _spellingNumber(fraction, language, longScale, shortScale);
      }
    }

    if (wholesSpelling != '') {
      wholesSpelling =
          wholesSpelling + ' ' + _spellingNumberDefault['wholesUnit'];
    }
    if (fractionSpelling != '') {
      fractionSpelling = ' ' +
          _spellingNumberDefault['decimalSeperator'] +
          ' ' +
          fractionSpelling +
          ' ' +
          _spellingNumberDefault['fractionUnit'];
    }

    return (wholesSpelling + fractionSpelling).trim();
  }
}
