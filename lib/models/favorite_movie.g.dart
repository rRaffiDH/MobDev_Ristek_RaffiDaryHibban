// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_movie.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteMovieAdapter extends TypeAdapter<FavoriteMovie> {
  @override
  final int typeId = 2;

  @override
  FavoriteMovie read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteMovie(
      id: fields[0] as int,
      title: fields[1] as String,
      posterPath: fields[2] as String,
      voteAverage: fields[3] as double,
      voteCount: fields[4] as int,
      overview: fields[5] as String,
      genreIds: (fields[6] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteMovie obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.posterPath)
      ..writeByte(3)
      ..write(obj.voteAverage)
      ..writeByte(4)
      ..write(obj.voteCount)
      ..writeByte(5)
      ..write(obj.overview)
      ..writeByte(6)
      ..write(obj.genreIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteMovieAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
