///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	// Translations
	Map<String, String> get a => {
		'a3dHammer': 'Hammer',
		'anchor': 'Anchor',
		'chessKnight': 'Chess Knight',
		'church': 'Church',
		'clubs': 'Clubs',
		'crownCoin': 'Coin',
		'dinosaur': 'Dinosaur',
		'elephant': 'Elephant',
		'elvenCastle': 'Castle',
		'fishbone': 'Fishbone',
		'fleurDeLys': 'Fleur De Lys',
		'frogFoot': 'Frog Foot',
		'gorilla': 'Gorilla',
		'grenade': 'Grenade',
		'labrador': 'Labrador',
		'largePaintBrush': 'Paint Brush',
		'lockedChest': 'Chest',
		'mayanPyramid': 'Pyramid',
		'monkey': 'Monkey',
		'mushroom': 'Mushroom',
		'northStar': 'Star',
		'octopus': 'Octopus',
		'paperClip': 'Paper Clip',
		'pirateFlag': 'Pirate Flag',
		'pistolGun': 'Pistol',
		'pumpkinLantern': 'Pumpkin',
		'roughWound': 'Lightning',
		'sailboat': 'Sailboat',
		'scissors': 'Scissors',
		'seaStar': 'Sea Star',
		'whiteTower': 'Tower',
		'wineGlass': 'Wine Glass',
	};
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'a.a3dHammer': return 'Hammer';
			case 'a.anchor': return 'Anchor';
			case 'a.chessKnight': return 'Chess Knight';
			case 'a.church': return 'Church';
			case 'a.clubs': return 'Clubs';
			case 'a.crownCoin': return 'Coin';
			case 'a.dinosaur': return 'Dinosaur';
			case 'a.elephant': return 'Elephant';
			case 'a.elvenCastle': return 'Castle';
			case 'a.fishbone': return 'Fishbone';
			case 'a.fleurDeLys': return 'Fleur De Lys';
			case 'a.frogFoot': return 'Frog Foot';
			case 'a.gorilla': return 'Gorilla';
			case 'a.grenade': return 'Grenade';
			case 'a.labrador': return 'Labrador';
			case 'a.largePaintBrush': return 'Paint Brush';
			case 'a.lockedChest': return 'Chest';
			case 'a.mayanPyramid': return 'Pyramid';
			case 'a.monkey': return 'Monkey';
			case 'a.mushroom': return 'Mushroom';
			case 'a.northStar': return 'Star';
			case 'a.octopus': return 'Octopus';
			case 'a.paperClip': return 'Paper Clip';
			case 'a.pirateFlag': return 'Pirate Flag';
			case 'a.pistolGun': return 'Pistol';
			case 'a.pumpkinLantern': return 'Pumpkin';
			case 'a.roughWound': return 'Lightning';
			case 'a.sailboat': return 'Sailboat';
			case 'a.scissors': return 'Scissors';
			case 'a.seaStar': return 'Sea Star';
			case 'a.whiteTower': return 'Tower';
			case 'a.wineGlass': return 'Wine Glass';
			default: return null;
		}
	}
}

