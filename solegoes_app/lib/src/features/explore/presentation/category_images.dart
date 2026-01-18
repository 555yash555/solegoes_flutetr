class CategoryImages {
  CategoryImages._();

  static const Map<String, String> _curatedImages = {
    'beach': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&q=80',
    'mountain': 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800&q=80',
    'hiking': 'https://images.unsplash.com/photo-1551632811-561732d1e306?w=800&q=80',
    'city': 'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=800&q=80',
    'adventure': 'https://images.unsplash.com/photo-1533130061792-649d45df4ddd?w=800&q=80',
    'party': 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=800&q=80',
    'nightlife': 'https://images.unsplash.com/photo-1566737236500-c8ac43014a67?w=800&q=80',
    'camping': 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=800&q=80',
    'road trip': 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800&q=80',
    'luxury': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&q=80',
    'budget': 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800&q=80', // Solo/backpack
    'family': 'https://images.unsplash.com/photo-1511895426328-dc8714191300?w=800&q=80',
    'solo': 'https://images.unsplash.com/photo-1501555088652-021faa106b9b?w=800&q=80',
    'nature': 'https://images.unsplash.com/photo-1472214103451-9374bd1c798e?w=800&q=80',
    'culture': 'https://images.unsplash.com/photo-1533929736472-594e4502af3f?w=800&q=80',
    'food': 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&q=80',
    'wildlife': 'https://images.unsplash.com/photo-1549366021-9f761d450615?w=800&q=80',
    'island': 'https://images.unsplash.com/photo-1559128010-7c1ad6e1b6a5?w=800&q=80',
    'forest': 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800&q=80',
    'desert': 'https://images.unsplash.com/photo-1473580044384-7ba9967e16a0?w=800&q=80',
    'snow': 'https://images.unsplash.com/photo-1517299321609-52687d1bc555?w=800&q=80',
    'history': 'https://images.unsplash.com/photo-1526566762798-8fac9c07aa98?w=800&q=80', // Rome
  };

  /// Returns a curated image URL for the known category.
  /// Returns [fallbackUrl] (from a trip) if the category is unknown.
  static String getImageUrl(String category, String fallbackUrl) {
    return _curatedImages[category.toLowerCase()] ?? fallbackUrl;
  }
}
