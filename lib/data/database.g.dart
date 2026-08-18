// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $QuestionsTable extends Questions
    with TableInfo<$QuestionsTable, QuestionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectMeta = const VerificationMeta(
    'subject',
  );
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
    'subject',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterMeta = const VerificationMeta(
    'chapter',
  );
  @override
  late final GeneratedColumn<String> chapter = GeneratedColumn<String>(
    'chapter',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _knowledgePointMeta = const VerificationMeta(
    'knowledgePoint',
  );
  @override
  late final GeneratedColumn<String> knowledgePoint = GeneratedColumn<String>(
    'knowledge_point',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _knowledgePointIdMeta = const VerificationMeta(
    'knowledgePointId',
  );
  @override
  late final GeneratedColumn<String> knowledgePointId = GeneratedColumn<String>(
    'knowledge_point_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stemMeta = const VerificationMeta('stem');
  @override
  late final GeneratedColumn<String> stem = GeneratedColumn<String>(
    'stem',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionsMeta = const VerificationMeta(
    'options',
  );
  @override
  late final GeneratedColumn<String> options = GeneratedColumn<String>(
    'options',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answerMeta = const VerificationMeta('answer');
  @override
  late final GeneratedColumn<String> answer = GeneratedColumn<String>(
    'answer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explanationMeta = const VerificationMeta(
    'explanation',
  );
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
    'explanation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    subject,
    chapter,
    knowledgePoint,
    knowledgePointId,
    type,
    stem,
    options,
    answer,
    explanation,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuestionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subject')) {
      context.handle(
        _subjectMeta,
        subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(
        _chapterMeta,
        chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    if (data.containsKey('knowledge_point')) {
      context.handle(
        _knowledgePointMeta,
        knowledgePoint.isAcceptableOrUnknown(
          data['knowledge_point']!,
          _knowledgePointMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_knowledgePointMeta);
    }
    if (data.containsKey('knowledge_point_id')) {
      context.handle(
        _knowledgePointIdMeta,
        knowledgePointId.isAcceptableOrUnknown(
          data['knowledge_point_id']!,
          _knowledgePointIdMeta,
        ),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('stem')) {
      context.handle(
        _stemMeta,
        stem.isAcceptableOrUnknown(data['stem']!, _stemMeta),
      );
    } else if (isInserting) {
      context.missing(_stemMeta);
    }
    if (data.containsKey('options')) {
      context.handle(
        _optionsMeta,
        options.isAcceptableOrUnknown(data['options']!, _optionsMeta),
      );
    } else if (isInserting) {
      context.missing(_optionsMeta);
    }
    if (data.containsKey('answer')) {
      context.handle(
        _answerMeta,
        answer.isAcceptableOrUnknown(data['answer']!, _answerMeta),
      );
    } else if (isInserting) {
      context.missing(_answerMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
        _explanationMeta,
        explanation.isAcceptableOrUnknown(
          data['explanation']!,
          _explanationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_explanationMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuestionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      subject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject'],
      )!,
      chapter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter'],
      )!,
      knowledgePoint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}knowledge_point'],
      )!,
      knowledgePointId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}knowledge_point_id'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      stem: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stem'],
      )!,
      options: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}options'],
      )!,
      answer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answer'],
      )!,
      explanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation'],
      )!,
    );
  }

  @override
  $QuestionsTable createAlias(String alias) {
    return $QuestionsTable(attachedDatabase, alias);
  }
}

class QuestionRow extends DataClass implements Insertable<QuestionRow> {
  final String id;
  final String subject;
  final String chapter;
  final String knowledgePoint;
  final String? knowledgePointId;
  final String type;
  final String stem;
  final String options;
  final String answer;
  final String explanation;
  const QuestionRow({
    required this.id,
    required this.subject,
    required this.chapter,
    required this.knowledgePoint,
    this.knowledgePointId,
    required this.type,
    required this.stem,
    required this.options,
    required this.answer,
    required this.explanation,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['subject'] = Variable<String>(subject);
    map['chapter'] = Variable<String>(chapter);
    map['knowledge_point'] = Variable<String>(knowledgePoint);
    if (!nullToAbsent || knowledgePointId != null) {
      map['knowledge_point_id'] = Variable<String>(knowledgePointId);
    }
    map['type'] = Variable<String>(type);
    map['stem'] = Variable<String>(stem);
    map['options'] = Variable<String>(options);
    map['answer'] = Variable<String>(answer);
    map['explanation'] = Variable<String>(explanation);
    return map;
  }

  QuestionsCompanion toCompanion(bool nullToAbsent) {
    return QuestionsCompanion(
      id: Value(id),
      subject: Value(subject),
      chapter: Value(chapter),
      knowledgePoint: Value(knowledgePoint),
      knowledgePointId: knowledgePointId == null && nullToAbsent
          ? const Value.absent()
          : Value(knowledgePointId),
      type: Value(type),
      stem: Value(stem),
      options: Value(options),
      answer: Value(answer),
      explanation: Value(explanation),
    );
  }

  factory QuestionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestionRow(
      id: serializer.fromJson<String>(json['id']),
      subject: serializer.fromJson<String>(json['subject']),
      chapter: serializer.fromJson<String>(json['chapter']),
      knowledgePoint: serializer.fromJson<String>(json['knowledgePoint']),
      knowledgePointId: serializer.fromJson<String?>(json['knowledgePointId']),
      type: serializer.fromJson<String>(json['type']),
      stem: serializer.fromJson<String>(json['stem']),
      options: serializer.fromJson<String>(json['options']),
      answer: serializer.fromJson<String>(json['answer']),
      explanation: serializer.fromJson<String>(json['explanation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subject': serializer.toJson<String>(subject),
      'chapter': serializer.toJson<String>(chapter),
      'knowledgePoint': serializer.toJson<String>(knowledgePoint),
      'knowledgePointId': serializer.toJson<String?>(knowledgePointId),
      'type': serializer.toJson<String>(type),
      'stem': serializer.toJson<String>(stem),
      'options': serializer.toJson<String>(options),
      'answer': serializer.toJson<String>(answer),
      'explanation': serializer.toJson<String>(explanation),
    };
  }

  QuestionRow copyWith({
    String? id,
    String? subject,
    String? chapter,
    String? knowledgePoint,
    Value<String?> knowledgePointId = const Value.absent(),
    String? type,
    String? stem,
    String? options,
    String? answer,
    String? explanation,
  }) => QuestionRow(
    id: id ?? this.id,
    subject: subject ?? this.subject,
    chapter: chapter ?? this.chapter,
    knowledgePoint: knowledgePoint ?? this.knowledgePoint,
    knowledgePointId: knowledgePointId.present
        ? knowledgePointId.value
        : this.knowledgePointId,
    type: type ?? this.type,
    stem: stem ?? this.stem,
    options: options ?? this.options,
    answer: answer ?? this.answer,
    explanation: explanation ?? this.explanation,
  );
  QuestionRow copyWithCompanion(QuestionsCompanion data) {
    return QuestionRow(
      id: data.id.present ? data.id.value : this.id,
      subject: data.subject.present ? data.subject.value : this.subject,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      knowledgePoint: data.knowledgePoint.present
          ? data.knowledgePoint.value
          : this.knowledgePoint,
      knowledgePointId: data.knowledgePointId.present
          ? data.knowledgePointId.value
          : this.knowledgePointId,
      type: data.type.present ? data.type.value : this.type,
      stem: data.stem.present ? data.stem.value : this.stem,
      options: data.options.present ? data.options.value : this.options,
      answer: data.answer.present ? data.answer.value : this.answer,
      explanation: data.explanation.present
          ? data.explanation.value
          : this.explanation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestionRow(')
          ..write('id: $id, ')
          ..write('subject: $subject, ')
          ..write('chapter: $chapter, ')
          ..write('knowledgePoint: $knowledgePoint, ')
          ..write('knowledgePointId: $knowledgePointId, ')
          ..write('type: $type, ')
          ..write('stem: $stem, ')
          ..write('options: $options, ')
          ..write('answer: $answer, ')
          ..write('explanation: $explanation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    subject,
    chapter,
    knowledgePoint,
    knowledgePointId,
    type,
    stem,
    options,
    answer,
    explanation,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestionRow &&
          other.id == this.id &&
          other.subject == this.subject &&
          other.chapter == this.chapter &&
          other.knowledgePoint == this.knowledgePoint &&
          other.knowledgePointId == this.knowledgePointId &&
          other.type == this.type &&
          other.stem == this.stem &&
          other.options == this.options &&
          other.answer == this.answer &&
          other.explanation == this.explanation);
}

class QuestionsCompanion extends UpdateCompanion<QuestionRow> {
  final Value<String> id;
  final Value<String> subject;
  final Value<String> chapter;
  final Value<String> knowledgePoint;
  final Value<String?> knowledgePointId;
  final Value<String> type;
  final Value<String> stem;
  final Value<String> options;
  final Value<String> answer;
  final Value<String> explanation;
  final Value<int> rowid;
  const QuestionsCompanion({
    this.id = const Value.absent(),
    this.subject = const Value.absent(),
    this.chapter = const Value.absent(),
    this.knowledgePoint = const Value.absent(),
    this.knowledgePointId = const Value.absent(),
    this.type = const Value.absent(),
    this.stem = const Value.absent(),
    this.options = const Value.absent(),
    this.answer = const Value.absent(),
    this.explanation = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestionsCompanion.insert({
    required String id,
    required String subject,
    required String chapter,
    required String knowledgePoint,
    this.knowledgePointId = const Value.absent(),
    required String type,
    required String stem,
    required String options,
    required String answer,
    required String explanation,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       subject = Value(subject),
       chapter = Value(chapter),
       knowledgePoint = Value(knowledgePoint),
       type = Value(type),
       stem = Value(stem),
       options = Value(options),
       answer = Value(answer),
       explanation = Value(explanation);
  static Insertable<QuestionRow> custom({
    Expression<String>? id,
    Expression<String>? subject,
    Expression<String>? chapter,
    Expression<String>? knowledgePoint,
    Expression<String>? knowledgePointId,
    Expression<String>? type,
    Expression<String>? stem,
    Expression<String>? options,
    Expression<String>? answer,
    Expression<String>? explanation,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subject != null) 'subject': subject,
      if (chapter != null) 'chapter': chapter,
      if (knowledgePoint != null) 'knowledge_point': knowledgePoint,
      if (knowledgePointId != null) 'knowledge_point_id': knowledgePointId,
      if (type != null) 'type': type,
      if (stem != null) 'stem': stem,
      if (options != null) 'options': options,
      if (answer != null) 'answer': answer,
      if (explanation != null) 'explanation': explanation,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestionsCompanion copyWith({
    Value<String>? id,
    Value<String>? subject,
    Value<String>? chapter,
    Value<String>? knowledgePoint,
    Value<String?>? knowledgePointId,
    Value<String>? type,
    Value<String>? stem,
    Value<String>? options,
    Value<String>? answer,
    Value<String>? explanation,
    Value<int>? rowid,
  }) {
    return QuestionsCompanion(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      chapter: chapter ?? this.chapter,
      knowledgePoint: knowledgePoint ?? this.knowledgePoint,
      knowledgePointId: knowledgePointId ?? this.knowledgePointId,
      type: type ?? this.type,
      stem: stem ?? this.stem,
      options: options ?? this.options,
      answer: answer ?? this.answer,
      explanation: explanation ?? this.explanation,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<String>(chapter.value);
    }
    if (knowledgePoint.present) {
      map['knowledge_point'] = Variable<String>(knowledgePoint.value);
    }
    if (knowledgePointId.present) {
      map['knowledge_point_id'] = Variable<String>(knowledgePointId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (stem.present) {
      map['stem'] = Variable<String>(stem.value);
    }
    if (options.present) {
      map['options'] = Variable<String>(options.value);
    }
    if (answer.present) {
      map['answer'] = Variable<String>(answer.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionsCompanion(')
          ..write('id: $id, ')
          ..write('subject: $subject, ')
          ..write('chapter: $chapter, ')
          ..write('knowledgePoint: $knowledgePoint, ')
          ..write('knowledgePointId: $knowledgePointId, ')
          ..write('type: $type, ')
          ..write('stem: $stem, ')
          ..write('options: $options, ')
          ..write('answer: $answer, ')
          ..write('explanation: $explanation, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CardsTable extends Cards with TableInfo<$CardsTable, CardRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
    'question_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<double> difficulty = GeneratedColumn<double>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _stabilityMeta = const VerificationMeta(
    'stability',
  );
  @override
  late final GeneratedColumn<double> stability = GeneratedColumn<double>(
    'stability',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dueMeta = const VerificationMeta('due');
  @override
  late final GeneratedColumn<int> due = GeneratedColumn<int>(
    'due',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastReviewMeta = const VerificationMeta(
    'lastReview',
  );
  @override
  late final GeneratedColumn<int> lastReview = GeneratedColumn<int>(
    'last_review',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lapsesMeta = const VerificationMeta('lapses');
  @override
  late final GeneratedColumn<int> lapses = GeneratedColumn<int>(
    'lapses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _suspendedMeta = const VerificationMeta(
    'suspended',
  );
  @override
  late final GeneratedColumn<int> suspended = GeneratedColumn<int>(
    'suspended',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    questionId,
    difficulty,
    stability,
    due,
    lastReview,
    reps,
    lapses,
    suspended,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    }
    if (data.containsKey('stability')) {
      context.handle(
        _stabilityMeta,
        stability.isAcceptableOrUnknown(data['stability']!, _stabilityMeta),
      );
    }
    if (data.containsKey('due')) {
      context.handle(
        _dueMeta,
        due.isAcceptableOrUnknown(data['due']!, _dueMeta),
      );
    }
    if (data.containsKey('last_review')) {
      context.handle(
        _lastReviewMeta,
        lastReview.isAcceptableOrUnknown(data['last_review']!, _lastReviewMeta),
      );
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    }
    if (data.containsKey('lapses')) {
      context.handle(
        _lapsesMeta,
        lapses.isAcceptableOrUnknown(data['lapses']!, _lapsesMeta),
      );
    }
    if (data.containsKey('suspended')) {
      context.handle(
        _suspendedMeta,
        suspended.isAcceptableOrUnknown(data['suspended']!, _suspendedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {questionId};
  @override
  CardRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardRow(
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_id'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}difficulty'],
      )!,
      stability: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stability'],
      )!,
      due: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due'],
      ),
      lastReview: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_review'],
      ),
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      )!,
      lapses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lapses'],
      )!,
      suspended: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}suspended'],
      )!,
    );
  }

  @override
  $CardsTable createAlias(String alias) {
    return $CardsTable(attachedDatabase, alias);
  }
}

class CardRow extends DataClass implements Insertable<CardRow> {
  final String questionId;
  final double difficulty;
  final double stability;
  final int? due;
  final int? lastReview;
  final int reps;
  final int lapses;
  final int suspended;
  const CardRow({
    required this.questionId,
    required this.difficulty,
    required this.stability,
    this.due,
    this.lastReview,
    required this.reps,
    required this.lapses,
    required this.suspended,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['question_id'] = Variable<String>(questionId);
    map['difficulty'] = Variable<double>(difficulty);
    map['stability'] = Variable<double>(stability);
    if (!nullToAbsent || due != null) {
      map['due'] = Variable<int>(due);
    }
    if (!nullToAbsent || lastReview != null) {
      map['last_review'] = Variable<int>(lastReview);
    }
    map['reps'] = Variable<int>(reps);
    map['lapses'] = Variable<int>(lapses);
    map['suspended'] = Variable<int>(suspended);
    return map;
  }

  CardsCompanion toCompanion(bool nullToAbsent) {
    return CardsCompanion(
      questionId: Value(questionId),
      difficulty: Value(difficulty),
      stability: Value(stability),
      due: due == null && nullToAbsent ? const Value.absent() : Value(due),
      lastReview: lastReview == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReview),
      reps: Value(reps),
      lapses: Value(lapses),
      suspended: Value(suspended),
    );
  }

  factory CardRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardRow(
      questionId: serializer.fromJson<String>(json['questionId']),
      difficulty: serializer.fromJson<double>(json['difficulty']),
      stability: serializer.fromJson<double>(json['stability']),
      due: serializer.fromJson<int?>(json['due']),
      lastReview: serializer.fromJson<int?>(json['lastReview']),
      reps: serializer.fromJson<int>(json['reps']),
      lapses: serializer.fromJson<int>(json['lapses']),
      suspended: serializer.fromJson<int>(json['suspended']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'questionId': serializer.toJson<String>(questionId),
      'difficulty': serializer.toJson<double>(difficulty),
      'stability': serializer.toJson<double>(stability),
      'due': serializer.toJson<int?>(due),
      'lastReview': serializer.toJson<int?>(lastReview),
      'reps': serializer.toJson<int>(reps),
      'lapses': serializer.toJson<int>(lapses),
      'suspended': serializer.toJson<int>(suspended),
    };
  }

  CardRow copyWith({
    String? questionId,
    double? difficulty,
    double? stability,
    Value<int?> due = const Value.absent(),
    Value<int?> lastReview = const Value.absent(),
    int? reps,
    int? lapses,
    int? suspended,
  }) => CardRow(
    questionId: questionId ?? this.questionId,
    difficulty: difficulty ?? this.difficulty,
    stability: stability ?? this.stability,
    due: due.present ? due.value : this.due,
    lastReview: lastReview.present ? lastReview.value : this.lastReview,
    reps: reps ?? this.reps,
    lapses: lapses ?? this.lapses,
    suspended: suspended ?? this.suspended,
  );
  CardRow copyWithCompanion(CardsCompanion data) {
    return CardRow(
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      stability: data.stability.present ? data.stability.value : this.stability,
      due: data.due.present ? data.due.value : this.due,
      lastReview: data.lastReview.present
          ? data.lastReview.value
          : this.lastReview,
      reps: data.reps.present ? data.reps.value : this.reps,
      lapses: data.lapses.present ? data.lapses.value : this.lapses,
      suspended: data.suspended.present ? data.suspended.value : this.suspended,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardRow(')
          ..write('questionId: $questionId, ')
          ..write('difficulty: $difficulty, ')
          ..write('stability: $stability, ')
          ..write('due: $due, ')
          ..write('lastReview: $lastReview, ')
          ..write('reps: $reps, ')
          ..write('lapses: $lapses, ')
          ..write('suspended: $suspended')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    questionId,
    difficulty,
    stability,
    due,
    lastReview,
    reps,
    lapses,
    suspended,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardRow &&
          other.questionId == this.questionId &&
          other.difficulty == this.difficulty &&
          other.stability == this.stability &&
          other.due == this.due &&
          other.lastReview == this.lastReview &&
          other.reps == this.reps &&
          other.lapses == this.lapses &&
          other.suspended == this.suspended);
}

class CardsCompanion extends UpdateCompanion<CardRow> {
  final Value<String> questionId;
  final Value<double> difficulty;
  final Value<double> stability;
  final Value<int?> due;
  final Value<int?> lastReview;
  final Value<int> reps;
  final Value<int> lapses;
  final Value<int> suspended;
  final Value<int> rowid;
  const CardsCompanion({
    this.questionId = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.stability = const Value.absent(),
    this.due = const Value.absent(),
    this.lastReview = const Value.absent(),
    this.reps = const Value.absent(),
    this.lapses = const Value.absent(),
    this.suspended = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardsCompanion.insert({
    required String questionId,
    this.difficulty = const Value.absent(),
    this.stability = const Value.absent(),
    this.due = const Value.absent(),
    this.lastReview = const Value.absent(),
    this.reps = const Value.absent(),
    this.lapses = const Value.absent(),
    this.suspended = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : questionId = Value(questionId);
  static Insertable<CardRow> custom({
    Expression<String>? questionId,
    Expression<double>? difficulty,
    Expression<double>? stability,
    Expression<int>? due,
    Expression<int>? lastReview,
    Expression<int>? reps,
    Expression<int>? lapses,
    Expression<int>? suspended,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (questionId != null) 'question_id': questionId,
      if (difficulty != null) 'difficulty': difficulty,
      if (stability != null) 'stability': stability,
      if (due != null) 'due': due,
      if (lastReview != null) 'last_review': lastReview,
      if (reps != null) 'reps': reps,
      if (lapses != null) 'lapses': lapses,
      if (suspended != null) 'suspended': suspended,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardsCompanion copyWith({
    Value<String>? questionId,
    Value<double>? difficulty,
    Value<double>? stability,
    Value<int?>? due,
    Value<int?>? lastReview,
    Value<int>? reps,
    Value<int>? lapses,
    Value<int>? suspended,
    Value<int>? rowid,
  }) {
    return CardsCompanion(
      questionId: questionId ?? this.questionId,
      difficulty: difficulty ?? this.difficulty,
      stability: stability ?? this.stability,
      due: due ?? this.due,
      lastReview: lastReview ?? this.lastReview,
      reps: reps ?? this.reps,
      lapses: lapses ?? this.lapses,
      suspended: suspended ?? this.suspended,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<double>(difficulty.value);
    }
    if (stability.present) {
      map['stability'] = Variable<double>(stability.value);
    }
    if (due.present) {
      map['due'] = Variable<int>(due.value);
    }
    if (lastReview.present) {
      map['last_review'] = Variable<int>(lastReview.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (lapses.present) {
      map['lapses'] = Variable<int>(lapses.value);
    }
    if (suspended.present) {
      map['suspended'] = Variable<int>(suspended.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardsCompanion(')
          ..write('questionId: $questionId, ')
          ..write('difficulty: $difficulty, ')
          ..write('stability: $stability, ')
          ..write('due: $due, ')
          ..write('lastReview: $lastReview, ')
          ..write('reps: $reps, ')
          ..write('lapses: $lapses, ')
          ..write('suspended: $suspended, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MetaEntriesTable extends MetaEntries
    with TableInfo<$MetaEntriesTable, MetaEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MetaEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<MetaEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  MetaEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MetaEntryRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $MetaEntriesTable createAlias(String alias) {
    return $MetaEntriesTable(attachedDatabase, alias);
  }
}

class MetaEntryRow extends DataClass implements Insertable<MetaEntryRow> {
  final String key;
  final String value;
  const MetaEntryRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  MetaEntriesCompanion toCompanion(bool nullToAbsent) {
    return MetaEntriesCompanion(key: Value(key), value: Value(value));
  }

  factory MetaEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MetaEntryRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  MetaEntryRow copyWith({String? key, String? value}) =>
      MetaEntryRow(key: key ?? this.key, value: value ?? this.value);
  MetaEntryRow copyWithCompanion(MetaEntriesCompanion data) {
    return MetaEntryRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MetaEntryRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MetaEntryRow &&
          other.key == this.key &&
          other.value == this.value);
}

class MetaEntriesCompanion extends UpdateCompanion<MetaEntryRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const MetaEntriesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MetaEntriesCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<MetaEntryRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MetaEntriesCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return MetaEntriesCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetaEntriesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyStatsTable extends DailyStats
    with TableInfo<$DailyStatsTable, DailyStatRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _newCountMeta = const VerificationMeta(
    'newCount',
  );
  @override
  late final GeneratedColumn<int> newCount = GeneratedColumn<int>(
    'new_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _reviewCountMeta = const VerificationMeta(
    'reviewCount',
  );
  @override
  late final GeneratedColumn<int> reviewCount = GeneratedColumn<int>(
    'review_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _correctCountMeta = const VerificationMeta(
    'correctCount',
  );
  @override
  late final GeneratedColumn<int> correctCount = GeneratedColumn<int>(
    'correct_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _graduatedCountMeta = const VerificationMeta(
    'graduatedCount',
  );
  @override
  late final GeneratedColumn<int> graduatedCount = GeneratedColumn<int>(
    'graduated_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _checkedInMeta = const VerificationMeta(
    'checkedIn',
  );
  @override
  late final GeneratedColumn<int> checkedIn = GeneratedColumn<int>(
    'checked_in',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _checkInTimeMeta = const VerificationMeta(
    'checkInTime',
  );
  @override
  late final GeneratedColumn<int> checkInTime = GeneratedColumn<int>(
    'check_in_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    date,
    newCount,
    reviewCount,
    correctCount,
    graduatedCount,
    checkedIn,
    checkInTime,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_stats';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyStatRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('new_count')) {
      context.handle(
        _newCountMeta,
        newCount.isAcceptableOrUnknown(data['new_count']!, _newCountMeta),
      );
    }
    if (data.containsKey('review_count')) {
      context.handle(
        _reviewCountMeta,
        reviewCount.isAcceptableOrUnknown(
          data['review_count']!,
          _reviewCountMeta,
        ),
      );
    }
    if (data.containsKey('correct_count')) {
      context.handle(
        _correctCountMeta,
        correctCount.isAcceptableOrUnknown(
          data['correct_count']!,
          _correctCountMeta,
        ),
      );
    }
    if (data.containsKey('graduated_count')) {
      context.handle(
        _graduatedCountMeta,
        graduatedCount.isAcceptableOrUnknown(
          data['graduated_count']!,
          _graduatedCountMeta,
        ),
      );
    }
    if (data.containsKey('checked_in')) {
      context.handle(
        _checkedInMeta,
        checkedIn.isAcceptableOrUnknown(data['checked_in']!, _checkedInMeta),
      );
    }
    if (data.containsKey('check_in_time')) {
      context.handle(
        _checkInTimeMeta,
        checkInTime.isAcceptableOrUnknown(
          data['check_in_time']!,
          _checkInTimeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  DailyStatRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyStatRow(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      newCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}new_count'],
      )!,
      reviewCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}review_count'],
      )!,
      correctCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_count'],
      )!,
      graduatedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}graduated_count'],
      )!,
      checkedIn: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}checked_in'],
      )!,
      checkInTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}check_in_time'],
      ),
    );
  }

  @override
  $DailyStatsTable createAlias(String alias) {
    return $DailyStatsTable(attachedDatabase, alias);
  }
}

class DailyStatRow extends DataClass implements Insertable<DailyStatRow> {
  final String date;
  final int newCount;
  final int reviewCount;
  final int correctCount;
  final int graduatedCount;
  final int checkedIn;
  final int? checkInTime;
  const DailyStatRow({
    required this.date,
    required this.newCount,
    required this.reviewCount,
    required this.correctCount,
    required this.graduatedCount,
    required this.checkedIn,
    this.checkInTime,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['new_count'] = Variable<int>(newCount);
    map['review_count'] = Variable<int>(reviewCount);
    map['correct_count'] = Variable<int>(correctCount);
    map['graduated_count'] = Variable<int>(graduatedCount);
    map['checked_in'] = Variable<int>(checkedIn);
    if (!nullToAbsent || checkInTime != null) {
      map['check_in_time'] = Variable<int>(checkInTime);
    }
    return map;
  }

  DailyStatsCompanion toCompanion(bool nullToAbsent) {
    return DailyStatsCompanion(
      date: Value(date),
      newCount: Value(newCount),
      reviewCount: Value(reviewCount),
      correctCount: Value(correctCount),
      graduatedCount: Value(graduatedCount),
      checkedIn: Value(checkedIn),
      checkInTime: checkInTime == null && nullToAbsent
          ? const Value.absent()
          : Value(checkInTime),
    );
  }

  factory DailyStatRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyStatRow(
      date: serializer.fromJson<String>(json['date']),
      newCount: serializer.fromJson<int>(json['newCount']),
      reviewCount: serializer.fromJson<int>(json['reviewCount']),
      correctCount: serializer.fromJson<int>(json['correctCount']),
      graduatedCount: serializer.fromJson<int>(json['graduatedCount']),
      checkedIn: serializer.fromJson<int>(json['checkedIn']),
      checkInTime: serializer.fromJson<int?>(json['checkInTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'newCount': serializer.toJson<int>(newCount),
      'reviewCount': serializer.toJson<int>(reviewCount),
      'correctCount': serializer.toJson<int>(correctCount),
      'graduatedCount': serializer.toJson<int>(graduatedCount),
      'checkedIn': serializer.toJson<int>(checkedIn),
      'checkInTime': serializer.toJson<int?>(checkInTime),
    };
  }

  DailyStatRow copyWith({
    String? date,
    int? newCount,
    int? reviewCount,
    int? correctCount,
    int? graduatedCount,
    int? checkedIn,
    Value<int?> checkInTime = const Value.absent(),
  }) => DailyStatRow(
    date: date ?? this.date,
    newCount: newCount ?? this.newCount,
    reviewCount: reviewCount ?? this.reviewCount,
    correctCount: correctCount ?? this.correctCount,
    graduatedCount: graduatedCount ?? this.graduatedCount,
    checkedIn: checkedIn ?? this.checkedIn,
    checkInTime: checkInTime.present ? checkInTime.value : this.checkInTime,
  );
  DailyStatRow copyWithCompanion(DailyStatsCompanion data) {
    return DailyStatRow(
      date: data.date.present ? data.date.value : this.date,
      newCount: data.newCount.present ? data.newCount.value : this.newCount,
      reviewCount: data.reviewCount.present
          ? data.reviewCount.value
          : this.reviewCount,
      correctCount: data.correctCount.present
          ? data.correctCount.value
          : this.correctCount,
      graduatedCount: data.graduatedCount.present
          ? data.graduatedCount.value
          : this.graduatedCount,
      checkedIn: data.checkedIn.present ? data.checkedIn.value : this.checkedIn,
      checkInTime: data.checkInTime.present
          ? data.checkInTime.value
          : this.checkInTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyStatRow(')
          ..write('date: $date, ')
          ..write('newCount: $newCount, ')
          ..write('reviewCount: $reviewCount, ')
          ..write('correctCount: $correctCount, ')
          ..write('graduatedCount: $graduatedCount, ')
          ..write('checkedIn: $checkedIn, ')
          ..write('checkInTime: $checkInTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    date,
    newCount,
    reviewCount,
    correctCount,
    graduatedCount,
    checkedIn,
    checkInTime,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyStatRow &&
          other.date == this.date &&
          other.newCount == this.newCount &&
          other.reviewCount == this.reviewCount &&
          other.correctCount == this.correctCount &&
          other.graduatedCount == this.graduatedCount &&
          other.checkedIn == this.checkedIn &&
          other.checkInTime == this.checkInTime);
}

class DailyStatsCompanion extends UpdateCompanion<DailyStatRow> {
  final Value<String> date;
  final Value<int> newCount;
  final Value<int> reviewCount;
  final Value<int> correctCount;
  final Value<int> graduatedCount;
  final Value<int> checkedIn;
  final Value<int?> checkInTime;
  final Value<int> rowid;
  const DailyStatsCompanion({
    this.date = const Value.absent(),
    this.newCount = const Value.absent(),
    this.reviewCount = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.graduatedCount = const Value.absent(),
    this.checkedIn = const Value.absent(),
    this.checkInTime = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyStatsCompanion.insert({
    required String date,
    this.newCount = const Value.absent(),
    this.reviewCount = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.graduatedCount = const Value.absent(),
    this.checkedIn = const Value.absent(),
    this.checkInTime = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date);
  static Insertable<DailyStatRow> custom({
    Expression<String>? date,
    Expression<int>? newCount,
    Expression<int>? reviewCount,
    Expression<int>? correctCount,
    Expression<int>? graduatedCount,
    Expression<int>? checkedIn,
    Expression<int>? checkInTime,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (newCount != null) 'new_count': newCount,
      if (reviewCount != null) 'review_count': reviewCount,
      if (correctCount != null) 'correct_count': correctCount,
      if (graduatedCount != null) 'graduated_count': graduatedCount,
      if (checkedIn != null) 'checked_in': checkedIn,
      if (checkInTime != null) 'check_in_time': checkInTime,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyStatsCompanion copyWith({
    Value<String>? date,
    Value<int>? newCount,
    Value<int>? reviewCount,
    Value<int>? correctCount,
    Value<int>? graduatedCount,
    Value<int>? checkedIn,
    Value<int?>? checkInTime,
    Value<int>? rowid,
  }) {
    return DailyStatsCompanion(
      date: date ?? this.date,
      newCount: newCount ?? this.newCount,
      reviewCount: reviewCount ?? this.reviewCount,
      correctCount: correctCount ?? this.correctCount,
      graduatedCount: graduatedCount ?? this.graduatedCount,
      checkedIn: checkedIn ?? this.checkedIn,
      checkInTime: checkInTime ?? this.checkInTime,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (newCount.present) {
      map['new_count'] = Variable<int>(newCount.value);
    }
    if (reviewCount.present) {
      map['review_count'] = Variable<int>(reviewCount.value);
    }
    if (correctCount.present) {
      map['correct_count'] = Variable<int>(correctCount.value);
    }
    if (graduatedCount.present) {
      map['graduated_count'] = Variable<int>(graduatedCount.value);
    }
    if (checkedIn.present) {
      map['checked_in'] = Variable<int>(checkedIn.value);
    }
    if (checkInTime.present) {
      map['check_in_time'] = Variable<int>(checkInTime.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyStatsCompanion(')
          ..write('date: $date, ')
          ..write('newCount: $newCount, ')
          ..write('reviewCount: $reviewCount, ')
          ..write('correctCount: $correctCount, ')
          ..write('graduatedCount: $graduatedCount, ')
          ..write('checkedIn: $checkedIn, ')
          ..write('checkInTime: $checkInTime, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReviewEventsTable extends ReviewEvents
    with TableInfo<$ReviewEventsTable, ReviewEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reviewedAtMeta = const VerificationMeta(
    'reviewedAt',
  );
  @override
  late final GeneratedColumn<int> reviewedAt = GeneratedColumn<int>(
    'reviewed_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctMeta = const VerificationMeta(
    'correct',
  );
  @override
  late final GeneratedColumn<int> correct = GeneratedColumn<int>(
    'correct',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isNewMeta = const VerificationMeta('isNew');
  @override
  late final GeneratedColumn<int> isNew = GeneratedColumn<int>(
    'is_new',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _graduatedMeta = const VerificationMeta(
    'graduated',
  );
  @override
  late final GeneratedColumn<int> graduated = GeneratedColumn<int>(
    'graduated',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventKindMeta = const VerificationMeta(
    'eventKind',
  );
  @override
  late final GeneratedColumn<String> eventKind = GeneratedColumn<String>(
    'event_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('rating'),
  );
  static const VerificationMeta _elapsedDaysMeta = const VerificationMeta(
    'elapsedDays',
  );
  @override
  late final GeneratedColumn<double> elapsedDays = GeneratedColumn<double>(
    'elapsed_days',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _previousDifficultyMeta =
      const VerificationMeta('previousDifficulty');
  @override
  late final GeneratedColumn<double> previousDifficulty =
      GeneratedColumn<double>(
        'previous_difficulty',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _previousStabilityMeta = const VerificationMeta(
    'previousStability',
  );
  @override
  late final GeneratedColumn<double> previousStability =
      GeneratedColumn<double>(
        'previous_stability',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _previousDueMeta = const VerificationMeta(
    'previousDue',
  );
  @override
  late final GeneratedColumn<int> previousDue = GeneratedColumn<int>(
    'previous_due',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _previousRepsMeta = const VerificationMeta(
    'previousReps',
  );
  @override
  late final GeneratedColumn<int> previousReps = GeneratedColumn<int>(
    'previous_reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _previousLapsesMeta = const VerificationMeta(
    'previousLapses',
  );
  @override
  late final GeneratedColumn<int> previousLapses = GeneratedColumn<int>(
    'previous_lapses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextDifficultyMeta = const VerificationMeta(
    'nextDifficulty',
  );
  @override
  late final GeneratedColumn<double> nextDifficulty = GeneratedColumn<double>(
    'next_difficulty',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextStabilityMeta = const VerificationMeta(
    'nextStability',
  );
  @override
  late final GeneratedColumn<double> nextStability = GeneratedColumn<double>(
    'next_stability',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextDueMeta = const VerificationMeta(
    'nextDue',
  );
  @override
  late final GeneratedColumn<int> nextDue = GeneratedColumn<int>(
    'next_due',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextRepsMeta = const VerificationMeta(
    'nextReps',
  );
  @override
  late final GeneratedColumn<int> nextReps = GeneratedColumn<int>(
    'next_reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextLapsesMeta = const VerificationMeta(
    'nextLapses',
  );
  @override
  late final GeneratedColumn<int> nextLapses = GeneratedColumn<int>(
    'next_lapses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _voidedMeta = const VerificationMeta('voided');
  @override
  late final GeneratedColumn<int> voided = GeneratedColumn<int>(
    'voided',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardId,
    reviewedAt,
    rating,
    correct,
    isNew,
    graduated,
    eventKind,
    elapsedDays,
    previousDifficulty,
    previousStability,
    previousDue,
    previousReps,
    previousLapses,
    nextDifficulty,
    nextStability,
    nextDue,
    nextReps,
    nextLapses,
    voided,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReviewEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('reviewed_at')) {
      context.handle(
        _reviewedAtMeta,
        reviewedAt.isAcceptableOrUnknown(data['reviewed_at']!, _reviewedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_reviewedAtMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    } else if (isInserting) {
      context.missing(_ratingMeta);
    }
    if (data.containsKey('correct')) {
      context.handle(
        _correctMeta,
        correct.isAcceptableOrUnknown(data['correct']!, _correctMeta),
      );
    } else if (isInserting) {
      context.missing(_correctMeta);
    }
    if (data.containsKey('is_new')) {
      context.handle(
        _isNewMeta,
        isNew.isAcceptableOrUnknown(data['is_new']!, _isNewMeta),
      );
    } else if (isInserting) {
      context.missing(_isNewMeta);
    }
    if (data.containsKey('graduated')) {
      context.handle(
        _graduatedMeta,
        graduated.isAcceptableOrUnknown(data['graduated']!, _graduatedMeta),
      );
    } else if (isInserting) {
      context.missing(_graduatedMeta);
    }
    if (data.containsKey('event_kind')) {
      context.handle(
        _eventKindMeta,
        eventKind.isAcceptableOrUnknown(data['event_kind']!, _eventKindMeta),
      );
    }
    if (data.containsKey('elapsed_days')) {
      context.handle(
        _elapsedDaysMeta,
        elapsedDays.isAcceptableOrUnknown(
          data['elapsed_days']!,
          _elapsedDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_elapsedDaysMeta);
    }
    if (data.containsKey('previous_difficulty')) {
      context.handle(
        _previousDifficultyMeta,
        previousDifficulty.isAcceptableOrUnknown(
          data['previous_difficulty']!,
          _previousDifficultyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_previousDifficultyMeta);
    }
    if (data.containsKey('previous_stability')) {
      context.handle(
        _previousStabilityMeta,
        previousStability.isAcceptableOrUnknown(
          data['previous_stability']!,
          _previousStabilityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_previousStabilityMeta);
    }
    if (data.containsKey('previous_due')) {
      context.handle(
        _previousDueMeta,
        previousDue.isAcceptableOrUnknown(
          data['previous_due']!,
          _previousDueMeta,
        ),
      );
    }
    if (data.containsKey('previous_reps')) {
      context.handle(
        _previousRepsMeta,
        previousReps.isAcceptableOrUnknown(
          data['previous_reps']!,
          _previousRepsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_previousRepsMeta);
    }
    if (data.containsKey('previous_lapses')) {
      context.handle(
        _previousLapsesMeta,
        previousLapses.isAcceptableOrUnknown(
          data['previous_lapses']!,
          _previousLapsesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_previousLapsesMeta);
    }
    if (data.containsKey('next_difficulty')) {
      context.handle(
        _nextDifficultyMeta,
        nextDifficulty.isAcceptableOrUnknown(
          data['next_difficulty']!,
          _nextDifficultyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextDifficultyMeta);
    }
    if (data.containsKey('next_stability')) {
      context.handle(
        _nextStabilityMeta,
        nextStability.isAcceptableOrUnknown(
          data['next_stability']!,
          _nextStabilityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextStabilityMeta);
    }
    if (data.containsKey('next_due')) {
      context.handle(
        _nextDueMeta,
        nextDue.isAcceptableOrUnknown(data['next_due']!, _nextDueMeta),
      );
    }
    if (data.containsKey('next_reps')) {
      context.handle(
        _nextRepsMeta,
        nextReps.isAcceptableOrUnknown(data['next_reps']!, _nextRepsMeta),
      );
    } else if (isInserting) {
      context.missing(_nextRepsMeta);
    }
    if (data.containsKey('next_lapses')) {
      context.handle(
        _nextLapsesMeta,
        nextLapses.isAcceptableOrUnknown(data['next_lapses']!, _nextLapsesMeta),
      );
    } else if (isInserting) {
      context.missing(_nextLapsesMeta);
    }
    if (data.containsKey('voided')) {
      context.handle(
        _voidedMeta,
        voided.isAcceptableOrUnknown(data['voided']!, _voidedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReviewEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewEventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      )!,
      reviewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reviewed_at'],
      )!,
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      )!,
      correct: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct'],
      )!,
      isNew: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_new'],
      )!,
      graduated: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}graduated'],
      )!,
      eventKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_kind'],
      )!,
      elapsedDays: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}elapsed_days'],
      )!,
      previousDifficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}previous_difficulty'],
      )!,
      previousStability: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}previous_stability'],
      )!,
      previousDue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}previous_due'],
      ),
      previousReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}previous_reps'],
      )!,
      previousLapses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}previous_lapses'],
      )!,
      nextDifficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}next_difficulty'],
      )!,
      nextStability: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}next_stability'],
      )!,
      nextDue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}next_due'],
      ),
      nextReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}next_reps'],
      )!,
      nextLapses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}next_lapses'],
      )!,
      voided: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}voided'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ReviewEventsTable createAlias(String alias) {
    return $ReviewEventsTable(attachedDatabase, alias);
  }
}

class ReviewEventRow extends DataClass implements Insertable<ReviewEventRow> {
  final int id;
  final String cardId;
  final int reviewedAt;
  final int rating;
  final int correct;
  final int isNew;
  final int graduated;
  final String eventKind;
  final double elapsedDays;
  final double previousDifficulty;
  final double previousStability;
  final int? previousDue;
  final int previousReps;
  final int previousLapses;
  final double nextDifficulty;
  final double nextStability;
  final int? nextDue;
  final int nextReps;
  final int nextLapses;
  final int voided;
  final int createdAt;
  const ReviewEventRow({
    required this.id,
    required this.cardId,
    required this.reviewedAt,
    required this.rating,
    required this.correct,
    required this.isNew,
    required this.graduated,
    required this.eventKind,
    required this.elapsedDays,
    required this.previousDifficulty,
    required this.previousStability,
    this.previousDue,
    required this.previousReps,
    required this.previousLapses,
    required this.nextDifficulty,
    required this.nextStability,
    this.nextDue,
    required this.nextReps,
    required this.nextLapses,
    required this.voided,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['card_id'] = Variable<String>(cardId);
    map['reviewed_at'] = Variable<int>(reviewedAt);
    map['rating'] = Variable<int>(rating);
    map['correct'] = Variable<int>(correct);
    map['is_new'] = Variable<int>(isNew);
    map['graduated'] = Variable<int>(graduated);
    map['event_kind'] = Variable<String>(eventKind);
    map['elapsed_days'] = Variable<double>(elapsedDays);
    map['previous_difficulty'] = Variable<double>(previousDifficulty);
    map['previous_stability'] = Variable<double>(previousStability);
    if (!nullToAbsent || previousDue != null) {
      map['previous_due'] = Variable<int>(previousDue);
    }
    map['previous_reps'] = Variable<int>(previousReps);
    map['previous_lapses'] = Variable<int>(previousLapses);
    map['next_difficulty'] = Variable<double>(nextDifficulty);
    map['next_stability'] = Variable<double>(nextStability);
    if (!nullToAbsent || nextDue != null) {
      map['next_due'] = Variable<int>(nextDue);
    }
    map['next_reps'] = Variable<int>(nextReps);
    map['next_lapses'] = Variable<int>(nextLapses);
    map['voided'] = Variable<int>(voided);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  ReviewEventsCompanion toCompanion(bool nullToAbsent) {
    return ReviewEventsCompanion(
      id: Value(id),
      cardId: Value(cardId),
      reviewedAt: Value(reviewedAt),
      rating: Value(rating),
      correct: Value(correct),
      isNew: Value(isNew),
      graduated: Value(graduated),
      eventKind: Value(eventKind),
      elapsedDays: Value(elapsedDays),
      previousDifficulty: Value(previousDifficulty),
      previousStability: Value(previousStability),
      previousDue: previousDue == null && nullToAbsent
          ? const Value.absent()
          : Value(previousDue),
      previousReps: Value(previousReps),
      previousLapses: Value(previousLapses),
      nextDifficulty: Value(nextDifficulty),
      nextStability: Value(nextStability),
      nextDue: nextDue == null && nullToAbsent
          ? const Value.absent()
          : Value(nextDue),
      nextReps: Value(nextReps),
      nextLapses: Value(nextLapses),
      voided: Value(voided),
      createdAt: Value(createdAt),
    );
  }

  factory ReviewEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewEventRow(
      id: serializer.fromJson<int>(json['id']),
      cardId: serializer.fromJson<String>(json['cardId']),
      reviewedAt: serializer.fromJson<int>(json['reviewedAt']),
      rating: serializer.fromJson<int>(json['rating']),
      correct: serializer.fromJson<int>(json['correct']),
      isNew: serializer.fromJson<int>(json['isNew']),
      graduated: serializer.fromJson<int>(json['graduated']),
      eventKind: serializer.fromJson<String>(json['eventKind']),
      elapsedDays: serializer.fromJson<double>(json['elapsedDays']),
      previousDifficulty: serializer.fromJson<double>(
        json['previousDifficulty'],
      ),
      previousStability: serializer.fromJson<double>(json['previousStability']),
      previousDue: serializer.fromJson<int?>(json['previousDue']),
      previousReps: serializer.fromJson<int>(json['previousReps']),
      previousLapses: serializer.fromJson<int>(json['previousLapses']),
      nextDifficulty: serializer.fromJson<double>(json['nextDifficulty']),
      nextStability: serializer.fromJson<double>(json['nextStability']),
      nextDue: serializer.fromJson<int?>(json['nextDue']),
      nextReps: serializer.fromJson<int>(json['nextReps']),
      nextLapses: serializer.fromJson<int>(json['nextLapses']),
      voided: serializer.fromJson<int>(json['voided']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cardId': serializer.toJson<String>(cardId),
      'reviewedAt': serializer.toJson<int>(reviewedAt),
      'rating': serializer.toJson<int>(rating),
      'correct': serializer.toJson<int>(correct),
      'isNew': serializer.toJson<int>(isNew),
      'graduated': serializer.toJson<int>(graduated),
      'eventKind': serializer.toJson<String>(eventKind),
      'elapsedDays': serializer.toJson<double>(elapsedDays),
      'previousDifficulty': serializer.toJson<double>(previousDifficulty),
      'previousStability': serializer.toJson<double>(previousStability),
      'previousDue': serializer.toJson<int?>(previousDue),
      'previousReps': serializer.toJson<int>(previousReps),
      'previousLapses': serializer.toJson<int>(previousLapses),
      'nextDifficulty': serializer.toJson<double>(nextDifficulty),
      'nextStability': serializer.toJson<double>(nextStability),
      'nextDue': serializer.toJson<int?>(nextDue),
      'nextReps': serializer.toJson<int>(nextReps),
      'nextLapses': serializer.toJson<int>(nextLapses),
      'voided': serializer.toJson<int>(voided),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  ReviewEventRow copyWith({
    int? id,
    String? cardId,
    int? reviewedAt,
    int? rating,
    int? correct,
    int? isNew,
    int? graduated,
    String? eventKind,
    double? elapsedDays,
    double? previousDifficulty,
    double? previousStability,
    Value<int?> previousDue = const Value.absent(),
    int? previousReps,
    int? previousLapses,
    double? nextDifficulty,
    double? nextStability,
    Value<int?> nextDue = const Value.absent(),
    int? nextReps,
    int? nextLapses,
    int? voided,
    int? createdAt,
  }) => ReviewEventRow(
    id: id ?? this.id,
    cardId: cardId ?? this.cardId,
    reviewedAt: reviewedAt ?? this.reviewedAt,
    rating: rating ?? this.rating,
    correct: correct ?? this.correct,
    isNew: isNew ?? this.isNew,
    graduated: graduated ?? this.graduated,
    eventKind: eventKind ?? this.eventKind,
    elapsedDays: elapsedDays ?? this.elapsedDays,
    previousDifficulty: previousDifficulty ?? this.previousDifficulty,
    previousStability: previousStability ?? this.previousStability,
    previousDue: previousDue.present ? previousDue.value : this.previousDue,
    previousReps: previousReps ?? this.previousReps,
    previousLapses: previousLapses ?? this.previousLapses,
    nextDifficulty: nextDifficulty ?? this.nextDifficulty,
    nextStability: nextStability ?? this.nextStability,
    nextDue: nextDue.present ? nextDue.value : this.nextDue,
    nextReps: nextReps ?? this.nextReps,
    nextLapses: nextLapses ?? this.nextLapses,
    voided: voided ?? this.voided,
    createdAt: createdAt ?? this.createdAt,
  );
  ReviewEventRow copyWithCompanion(ReviewEventsCompanion data) {
    return ReviewEventRow(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      reviewedAt: data.reviewedAt.present
          ? data.reviewedAt.value
          : this.reviewedAt,
      rating: data.rating.present ? data.rating.value : this.rating,
      correct: data.correct.present ? data.correct.value : this.correct,
      isNew: data.isNew.present ? data.isNew.value : this.isNew,
      graduated: data.graduated.present ? data.graduated.value : this.graduated,
      eventKind: data.eventKind.present ? data.eventKind.value : this.eventKind,
      elapsedDays: data.elapsedDays.present
          ? data.elapsedDays.value
          : this.elapsedDays,
      previousDifficulty: data.previousDifficulty.present
          ? data.previousDifficulty.value
          : this.previousDifficulty,
      previousStability: data.previousStability.present
          ? data.previousStability.value
          : this.previousStability,
      previousDue: data.previousDue.present
          ? data.previousDue.value
          : this.previousDue,
      previousReps: data.previousReps.present
          ? data.previousReps.value
          : this.previousReps,
      previousLapses: data.previousLapses.present
          ? data.previousLapses.value
          : this.previousLapses,
      nextDifficulty: data.nextDifficulty.present
          ? data.nextDifficulty.value
          : this.nextDifficulty,
      nextStability: data.nextStability.present
          ? data.nextStability.value
          : this.nextStability,
      nextDue: data.nextDue.present ? data.nextDue.value : this.nextDue,
      nextReps: data.nextReps.present ? data.nextReps.value : this.nextReps,
      nextLapses: data.nextLapses.present
          ? data.nextLapses.value
          : this.nextLapses,
      voided: data.voided.present ? data.voided.value : this.voided,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewEventRow(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('rating: $rating, ')
          ..write('correct: $correct, ')
          ..write('isNew: $isNew, ')
          ..write('graduated: $graduated, ')
          ..write('eventKind: $eventKind, ')
          ..write('elapsedDays: $elapsedDays, ')
          ..write('previousDifficulty: $previousDifficulty, ')
          ..write('previousStability: $previousStability, ')
          ..write('previousDue: $previousDue, ')
          ..write('previousReps: $previousReps, ')
          ..write('previousLapses: $previousLapses, ')
          ..write('nextDifficulty: $nextDifficulty, ')
          ..write('nextStability: $nextStability, ')
          ..write('nextDue: $nextDue, ')
          ..write('nextReps: $nextReps, ')
          ..write('nextLapses: $nextLapses, ')
          ..write('voided: $voided, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    cardId,
    reviewedAt,
    rating,
    correct,
    isNew,
    graduated,
    eventKind,
    elapsedDays,
    previousDifficulty,
    previousStability,
    previousDue,
    previousReps,
    previousLapses,
    nextDifficulty,
    nextStability,
    nextDue,
    nextReps,
    nextLapses,
    voided,
    createdAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewEventRow &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.reviewedAt == this.reviewedAt &&
          other.rating == this.rating &&
          other.correct == this.correct &&
          other.isNew == this.isNew &&
          other.graduated == this.graduated &&
          other.eventKind == this.eventKind &&
          other.elapsedDays == this.elapsedDays &&
          other.previousDifficulty == this.previousDifficulty &&
          other.previousStability == this.previousStability &&
          other.previousDue == this.previousDue &&
          other.previousReps == this.previousReps &&
          other.previousLapses == this.previousLapses &&
          other.nextDifficulty == this.nextDifficulty &&
          other.nextStability == this.nextStability &&
          other.nextDue == this.nextDue &&
          other.nextReps == this.nextReps &&
          other.nextLapses == this.nextLapses &&
          other.voided == this.voided &&
          other.createdAt == this.createdAt);
}

class ReviewEventsCompanion extends UpdateCompanion<ReviewEventRow> {
  final Value<int> id;
  final Value<String> cardId;
  final Value<int> reviewedAt;
  final Value<int> rating;
  final Value<int> correct;
  final Value<int> isNew;
  final Value<int> graduated;
  final Value<String> eventKind;
  final Value<double> elapsedDays;
  final Value<double> previousDifficulty;
  final Value<double> previousStability;
  final Value<int?> previousDue;
  final Value<int> previousReps;
  final Value<int> previousLapses;
  final Value<double> nextDifficulty;
  final Value<double> nextStability;
  final Value<int?> nextDue;
  final Value<int> nextReps;
  final Value<int> nextLapses;
  final Value<int> voided;
  final Value<int> createdAt;
  const ReviewEventsCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.reviewedAt = const Value.absent(),
    this.rating = const Value.absent(),
    this.correct = const Value.absent(),
    this.isNew = const Value.absent(),
    this.graduated = const Value.absent(),
    this.eventKind = const Value.absent(),
    this.elapsedDays = const Value.absent(),
    this.previousDifficulty = const Value.absent(),
    this.previousStability = const Value.absent(),
    this.previousDue = const Value.absent(),
    this.previousReps = const Value.absent(),
    this.previousLapses = const Value.absent(),
    this.nextDifficulty = const Value.absent(),
    this.nextStability = const Value.absent(),
    this.nextDue = const Value.absent(),
    this.nextReps = const Value.absent(),
    this.nextLapses = const Value.absent(),
    this.voided = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ReviewEventsCompanion.insert({
    this.id = const Value.absent(),
    required String cardId,
    required int reviewedAt,
    required int rating,
    required int correct,
    required int isNew,
    required int graduated,
    this.eventKind = const Value.absent(),
    required double elapsedDays,
    required double previousDifficulty,
    required double previousStability,
    this.previousDue = const Value.absent(),
    required int previousReps,
    required int previousLapses,
    required double nextDifficulty,
    required double nextStability,
    this.nextDue = const Value.absent(),
    required int nextReps,
    required int nextLapses,
    this.voided = const Value.absent(),
    required int createdAt,
  }) : cardId = Value(cardId),
       reviewedAt = Value(reviewedAt),
       rating = Value(rating),
       correct = Value(correct),
       isNew = Value(isNew),
       graduated = Value(graduated),
       elapsedDays = Value(elapsedDays),
       previousDifficulty = Value(previousDifficulty),
       previousStability = Value(previousStability),
       previousReps = Value(previousReps),
       previousLapses = Value(previousLapses),
       nextDifficulty = Value(nextDifficulty),
       nextStability = Value(nextStability),
       nextReps = Value(nextReps),
       nextLapses = Value(nextLapses),
       createdAt = Value(createdAt);
  static Insertable<ReviewEventRow> custom({
    Expression<int>? id,
    Expression<String>? cardId,
    Expression<int>? reviewedAt,
    Expression<int>? rating,
    Expression<int>? correct,
    Expression<int>? isNew,
    Expression<int>? graduated,
    Expression<String>? eventKind,
    Expression<double>? elapsedDays,
    Expression<double>? previousDifficulty,
    Expression<double>? previousStability,
    Expression<int>? previousDue,
    Expression<int>? previousReps,
    Expression<int>? previousLapses,
    Expression<double>? nextDifficulty,
    Expression<double>? nextStability,
    Expression<int>? nextDue,
    Expression<int>? nextReps,
    Expression<int>? nextLapses,
    Expression<int>? voided,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (reviewedAt != null) 'reviewed_at': reviewedAt,
      if (rating != null) 'rating': rating,
      if (correct != null) 'correct': correct,
      if (isNew != null) 'is_new': isNew,
      if (graduated != null) 'graduated': graduated,
      if (eventKind != null) 'event_kind': eventKind,
      if (elapsedDays != null) 'elapsed_days': elapsedDays,
      if (previousDifficulty != null) 'previous_difficulty': previousDifficulty,
      if (previousStability != null) 'previous_stability': previousStability,
      if (previousDue != null) 'previous_due': previousDue,
      if (previousReps != null) 'previous_reps': previousReps,
      if (previousLapses != null) 'previous_lapses': previousLapses,
      if (nextDifficulty != null) 'next_difficulty': nextDifficulty,
      if (nextStability != null) 'next_stability': nextStability,
      if (nextDue != null) 'next_due': nextDue,
      if (nextReps != null) 'next_reps': nextReps,
      if (nextLapses != null) 'next_lapses': nextLapses,
      if (voided != null) 'voided': voided,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ReviewEventsCompanion copyWith({
    Value<int>? id,
    Value<String>? cardId,
    Value<int>? reviewedAt,
    Value<int>? rating,
    Value<int>? correct,
    Value<int>? isNew,
    Value<int>? graduated,
    Value<String>? eventKind,
    Value<double>? elapsedDays,
    Value<double>? previousDifficulty,
    Value<double>? previousStability,
    Value<int?>? previousDue,
    Value<int>? previousReps,
    Value<int>? previousLapses,
    Value<double>? nextDifficulty,
    Value<double>? nextStability,
    Value<int?>? nextDue,
    Value<int>? nextReps,
    Value<int>? nextLapses,
    Value<int>? voided,
    Value<int>? createdAt,
  }) {
    return ReviewEventsCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      rating: rating ?? this.rating,
      correct: correct ?? this.correct,
      isNew: isNew ?? this.isNew,
      graduated: graduated ?? this.graduated,
      eventKind: eventKind ?? this.eventKind,
      elapsedDays: elapsedDays ?? this.elapsedDays,
      previousDifficulty: previousDifficulty ?? this.previousDifficulty,
      previousStability: previousStability ?? this.previousStability,
      previousDue: previousDue ?? this.previousDue,
      previousReps: previousReps ?? this.previousReps,
      previousLapses: previousLapses ?? this.previousLapses,
      nextDifficulty: nextDifficulty ?? this.nextDifficulty,
      nextStability: nextStability ?? this.nextStability,
      nextDue: nextDue ?? this.nextDue,
      nextReps: nextReps ?? this.nextReps,
      nextLapses: nextLapses ?? this.nextLapses,
      voided: voided ?? this.voided,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (reviewedAt.present) {
      map['reviewed_at'] = Variable<int>(reviewedAt.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (correct.present) {
      map['correct'] = Variable<int>(correct.value);
    }
    if (isNew.present) {
      map['is_new'] = Variable<int>(isNew.value);
    }
    if (graduated.present) {
      map['graduated'] = Variable<int>(graduated.value);
    }
    if (eventKind.present) {
      map['event_kind'] = Variable<String>(eventKind.value);
    }
    if (elapsedDays.present) {
      map['elapsed_days'] = Variable<double>(elapsedDays.value);
    }
    if (previousDifficulty.present) {
      map['previous_difficulty'] = Variable<double>(previousDifficulty.value);
    }
    if (previousStability.present) {
      map['previous_stability'] = Variable<double>(previousStability.value);
    }
    if (previousDue.present) {
      map['previous_due'] = Variable<int>(previousDue.value);
    }
    if (previousReps.present) {
      map['previous_reps'] = Variable<int>(previousReps.value);
    }
    if (previousLapses.present) {
      map['previous_lapses'] = Variable<int>(previousLapses.value);
    }
    if (nextDifficulty.present) {
      map['next_difficulty'] = Variable<double>(nextDifficulty.value);
    }
    if (nextStability.present) {
      map['next_stability'] = Variable<double>(nextStability.value);
    }
    if (nextDue.present) {
      map['next_due'] = Variable<int>(nextDue.value);
    }
    if (nextReps.present) {
      map['next_reps'] = Variable<int>(nextReps.value);
    }
    if (nextLapses.present) {
      map['next_lapses'] = Variable<int>(nextLapses.value);
    }
    if (voided.present) {
      map['voided'] = Variable<int>(voided.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewEventsCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('rating: $rating, ')
          ..write('correct: $correct, ')
          ..write('isNew: $isNew, ')
          ..write('graduated: $graduated, ')
          ..write('eventKind: $eventKind, ')
          ..write('elapsedDays: $elapsedDays, ')
          ..write('previousDifficulty: $previousDifficulty, ')
          ..write('previousStability: $previousStability, ')
          ..write('previousDue: $previousDue, ')
          ..write('previousReps: $previousReps, ')
          ..write('previousLapses: $previousLapses, ')
          ..write('nextDifficulty: $nextDifficulty, ')
          ..write('nextStability: $nextStability, ')
          ..write('nextDue: $nextDue, ')
          ..write('nextReps: $nextReps, ')
          ..write('nextLapses: $nextLapses, ')
          ..write('voided: $voided, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$DatabaseHelper extends GeneratedDatabase {
  _$DatabaseHelper(QueryExecutor e) : super(e);
  $DatabaseHelperManager get managers => $DatabaseHelperManager(this);
  late final $QuestionsTable questions = $QuestionsTable(this);
  late final $CardsTable cards = $CardsTable(this);
  late final $MetaEntriesTable metaEntries = $MetaEntriesTable(this);
  late final $DailyStatsTable dailyStats = $DailyStatsTable(this);
  late final $ReviewEventsTable reviewEvents = $ReviewEventsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    questions,
    cards,
    metaEntries,
    dailyStats,
    reviewEvents,
  ];
}

typedef $$QuestionsTableCreateCompanionBuilder = QuestionsCompanion Function({
  required String id,
  required String subject,
  required String chapter,
  required String knowledgePoint,
  Value<String?> knowledgePointId,
  required String type,
  required String stem,
  required String options,
  required String answer,
  required String explanation,
  Value<int> rowid,
});
typedef $$QuestionsTableUpdateCompanionBuilder = QuestionsCompanion Function({
  Value<String> id,
  Value<String> subject,
  Value<String> chapter,
  Value<String> knowledgePoint,
  Value<String?> knowledgePointId,
  Value<String> type,
  Value<String> stem,
  Value<String> options,
  Value<String> answer,
  Value<String> explanation,
  Value<int> rowid,
});

class $$QuestionsTableFilterComposer
    extends Composer<_$DatabaseHelper, $QuestionsTable> {
  $$QuestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get knowledgePoint => $composableBuilder(
    column: $table.knowledgePoint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get knowledgePointId => $composableBuilder(
    column: $table.knowledgePointId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stem => $composableBuilder(
    column: $table.stem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get options => $composableBuilder(
    column: $table.options,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answer => $composableBuilder(
    column: $table.answer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuestionsTableOrderingComposer
    extends Composer<_$DatabaseHelper, $QuestionsTable> {
  $$QuestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get knowledgePoint => $composableBuilder(
    column: $table.knowledgePoint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get knowledgePointId => $composableBuilder(
    column: $table.knowledgePointId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stem => $composableBuilder(
    column: $table.stem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get options => $composableBuilder(
    column: $table.options,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answer => $composableBuilder(
    column: $table.answer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuestionsTableAnnotationComposer
    extends Composer<_$DatabaseHelper, $QuestionsTable> {
  $$QuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<String> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<String> get knowledgePoint => $composableBuilder(
    column: $table.knowledgePoint,
    builder: (column) => column,
  );

  GeneratedColumn<String> get knowledgePointId => $composableBuilder(
    column: $table.knowledgePointId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get stem =>
      $composableBuilder(column: $table.stem, builder: (column) => column);

  GeneratedColumn<String> get options =>
      $composableBuilder(column: $table.options, builder: (column) => column);

  GeneratedColumn<String> get answer =>
      $composableBuilder(column: $table.answer, builder: (column) => column);

  GeneratedColumn<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => column,
  );
}

class $$QuestionsTableTableManager
    extends
        RootTableManager<
          _$DatabaseHelper,
          $QuestionsTable,
          QuestionRow,
          $$QuestionsTableFilterComposer,
          $$QuestionsTableOrderingComposer,
          $$QuestionsTableAnnotationComposer,
          $$QuestionsTableCreateCompanionBuilder,
          $$QuestionsTableUpdateCompanionBuilder,
          (
            QuestionRow,
            BaseReferences<_$DatabaseHelper, $QuestionsTable, QuestionRow>,
          ),
          QuestionRow,
          PrefetchHooks Function()
        > {
  $$QuestionsTableTableManager(_$DatabaseHelper db, $QuestionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> subject = const Value.absent(),
                Value<String> chapter = const Value.absent(),
                Value<String> knowledgePoint = const Value.absent(),
                Value<String?> knowledgePointId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> stem = const Value.absent(),
                Value<String> options = const Value.absent(),
                Value<String> answer = const Value.absent(),
                Value<String> explanation = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestionsCompanion(
                id: id,
                subject: subject,
                chapter: chapter,
                knowledgePoint: knowledgePoint,
                knowledgePointId: knowledgePointId,
                type: type,
                stem: stem,
                options: options,
                answer: answer,
                explanation: explanation,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String subject,
                required String chapter,
                required String knowledgePoint,
                Value<String?> knowledgePointId = const Value.absent(),
                required String type,
                required String stem,
                required String options,
                required String answer,
                required String explanation,
                Value<int> rowid = const Value.absent(),
              }) => QuestionsCompanion.insert(
                id: id,
                subject: subject,
                chapter: chapter,
                knowledgePoint: knowledgePoint,
                knowledgePointId: knowledgePointId,
                type: type,
                stem: stem,
                options: options,
                answer: answer,
                explanation: explanation,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$DatabaseHelper,
      $QuestionsTable,
      QuestionRow,
      $$QuestionsTableFilterComposer,
      $$QuestionsTableOrderingComposer,
      $$QuestionsTableAnnotationComposer,
      $$QuestionsTableCreateCompanionBuilder,
      $$QuestionsTableUpdateCompanionBuilder,
      (
        QuestionRow,
        BaseReferences<_$DatabaseHelper, $QuestionsTable, QuestionRow>,
      ),
      QuestionRow,
      PrefetchHooks Function()
    >;
typedef $$CardsTableCreateCompanionBuilder = CardsCompanion Function({
  required String questionId,
  Value<double> difficulty,
  Value<double> stability,
  Value<int?> due,
  Value<int?> lastReview,
  Value<int> reps,
  Value<int> lapses,
  Value<int> suspended,
  Value<int> rowid,
});
typedef $$CardsTableUpdateCompanionBuilder = CardsCompanion Function({
  Value<String> questionId,
  Value<double> difficulty,
  Value<double> stability,
  Value<int?> due,
  Value<int?> lastReview,
  Value<int> reps,
  Value<int> lapses,
  Value<int> suspended,
  Value<int> rowid,
});

class $$CardsTableFilterComposer
    extends Composer<_$DatabaseHelper, $CardsTable> {
  $$CardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stability => $composableBuilder(
    column: $table.stability,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastReview => $composableBuilder(
    column: $table.lastReview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get suspended => $composableBuilder(
    column: $table.suspended,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CardsTableOrderingComposer
    extends Composer<_$DatabaseHelper, $CardsTable> {
  $$CardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stability => $composableBuilder(
    column: $table.stability,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastReview => $composableBuilder(
    column: $table.lastReview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get suspended => $composableBuilder(
    column: $table.suspended,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CardsTableAnnotationComposer
    extends Composer<_$DatabaseHelper, $CardsTable> {
  $$CardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<double> get stability =>
      $composableBuilder(column: $table.stability, builder: (column) => column);

  GeneratedColumn<int> get due =>
      $composableBuilder(column: $table.due, builder: (column) => column);

  GeneratedColumn<int> get lastReview => $composableBuilder(
    column: $table.lastReview,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get lapses =>
      $composableBuilder(column: $table.lapses, builder: (column) => column);

  GeneratedColumn<int> get suspended =>
      $composableBuilder(column: $table.suspended, builder: (column) => column);
}

class $$CardsTableTableManager
    extends
        RootTableManager<
          _$DatabaseHelper,
          $CardsTable,
          CardRow,
          $$CardsTableFilterComposer,
          $$CardsTableOrderingComposer,
          $$CardsTableAnnotationComposer,
          $$CardsTableCreateCompanionBuilder,
          $$CardsTableUpdateCompanionBuilder,
          (CardRow, BaseReferences<_$DatabaseHelper, $CardsTable, CardRow>),
          CardRow,
          PrefetchHooks Function()
        > {
  $$CardsTableTableManager(_$DatabaseHelper db, $CardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> questionId = const Value.absent(),
                Value<double> difficulty = const Value.absent(),
                Value<double> stability = const Value.absent(),
                Value<int?> due = const Value.absent(),
                Value<int?> lastReview = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                Value<int> suspended = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardsCompanion(
                questionId: questionId,
                difficulty: difficulty,
                stability: stability,
                due: due,
                lastReview: lastReview,
                reps: reps,
                lapses: lapses,
                suspended: suspended,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String questionId,
                Value<double> difficulty = const Value.absent(),
                Value<double> stability = const Value.absent(),
                Value<int?> due = const Value.absent(),
                Value<int?> lastReview = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                Value<int> suspended = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardsCompanion.insert(
                questionId: questionId,
                difficulty: difficulty,
                stability: stability,
                due: due,
                lastReview: lastReview,
                reps: reps,
                lapses: lapses,
                suspended: suspended,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CardsTableProcessedTableManager =
    ProcessedTableManager<
      _$DatabaseHelper,
      $CardsTable,
      CardRow,
      $$CardsTableFilterComposer,
      $$CardsTableOrderingComposer,
      $$CardsTableAnnotationComposer,
      $$CardsTableCreateCompanionBuilder,
      $$CardsTableUpdateCompanionBuilder,
      (CardRow, BaseReferences<_$DatabaseHelper, $CardsTable, CardRow>),
      CardRow,
      PrefetchHooks Function()
    >;
typedef $$MetaEntriesTableCreateCompanionBuilder =
    MetaEntriesCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$MetaEntriesTableUpdateCompanionBuilder =
    MetaEntriesCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$MetaEntriesTableFilterComposer
    extends Composer<_$DatabaseHelper, $MetaEntriesTable> {
  $$MetaEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MetaEntriesTableOrderingComposer
    extends Composer<_$DatabaseHelper, $MetaEntriesTable> {
  $$MetaEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MetaEntriesTableAnnotationComposer
    extends Composer<_$DatabaseHelper, $MetaEntriesTable> {
  $$MetaEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$MetaEntriesTableTableManager
    extends
        RootTableManager<
          _$DatabaseHelper,
          $MetaEntriesTable,
          MetaEntryRow,
          $$MetaEntriesTableFilterComposer,
          $$MetaEntriesTableOrderingComposer,
          $$MetaEntriesTableAnnotationComposer,
          $$MetaEntriesTableCreateCompanionBuilder,
          $$MetaEntriesTableUpdateCompanionBuilder,
          (
            MetaEntryRow,
            BaseReferences<_$DatabaseHelper, $MetaEntriesTable, MetaEntryRow>,
          ),
          MetaEntryRow,
          PrefetchHooks Function()
        > {
  $$MetaEntriesTableTableManager(_$DatabaseHelper db, $MetaEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MetaEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MetaEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MetaEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => MetaEntriesCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => MetaEntriesCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MetaEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$DatabaseHelper,
      $MetaEntriesTable,
      MetaEntryRow,
      $$MetaEntriesTableFilterComposer,
      $$MetaEntriesTableOrderingComposer,
      $$MetaEntriesTableAnnotationComposer,
      $$MetaEntriesTableCreateCompanionBuilder,
      $$MetaEntriesTableUpdateCompanionBuilder,
      (
        MetaEntryRow,
        BaseReferences<_$DatabaseHelper, $MetaEntriesTable, MetaEntryRow>,
      ),
      MetaEntryRow,
      PrefetchHooks Function()
    >;
typedef $$DailyStatsTableCreateCompanionBuilder = DailyStatsCompanion Function({
  required String date,
  Value<int> newCount,
  Value<int> reviewCount,
  Value<int> correctCount,
  Value<int> graduatedCount,
  Value<int> checkedIn,
  Value<int?> checkInTime,
  Value<int> rowid,
});
typedef $$DailyStatsTableUpdateCompanionBuilder = DailyStatsCompanion Function({
  Value<String> date,
  Value<int> newCount,
  Value<int> reviewCount,
  Value<int> correctCount,
  Value<int> graduatedCount,
  Value<int> checkedIn,
  Value<int?> checkInTime,
  Value<int> rowid,
});

class $$DailyStatsTableFilterComposer
    extends Composer<_$DatabaseHelper, $DailyStatsTable> {
  $$DailyStatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get newCount => $composableBuilder(
    column: $table.newCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reviewCount => $composableBuilder(
    column: $table.reviewCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get graduatedCount => $composableBuilder(
    column: $table.graduatedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get checkedIn => $composableBuilder(
    column: $table.checkedIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get checkInTime => $composableBuilder(
    column: $table.checkInTime,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyStatsTableOrderingComposer
    extends Composer<_$DatabaseHelper, $DailyStatsTable> {
  $$DailyStatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get newCount => $composableBuilder(
    column: $table.newCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reviewCount => $composableBuilder(
    column: $table.reviewCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get graduatedCount => $composableBuilder(
    column: $table.graduatedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get checkedIn => $composableBuilder(
    column: $table.checkedIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get checkInTime => $composableBuilder(
    column: $table.checkInTime,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyStatsTableAnnotationComposer
    extends Composer<_$DatabaseHelper, $DailyStatsTable> {
  $$DailyStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get newCount =>
      $composableBuilder(column: $table.newCount, builder: (column) => column);

  GeneratedColumn<int> get reviewCount => $composableBuilder(
    column: $table.reviewCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get graduatedCount => $composableBuilder(
    column: $table.graduatedCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get checkedIn =>
      $composableBuilder(column: $table.checkedIn, builder: (column) => column);

  GeneratedColumn<int> get checkInTime => $composableBuilder(
    column: $table.checkInTime,
    builder: (column) => column,
  );
}

class $$DailyStatsTableTableManager
    extends
        RootTableManager<
          _$DatabaseHelper,
          $DailyStatsTable,
          DailyStatRow,
          $$DailyStatsTableFilterComposer,
          $$DailyStatsTableOrderingComposer,
          $$DailyStatsTableAnnotationComposer,
          $$DailyStatsTableCreateCompanionBuilder,
          $$DailyStatsTableUpdateCompanionBuilder,
          (
            DailyStatRow,
            BaseReferences<_$DatabaseHelper, $DailyStatsTable, DailyStatRow>,
          ),
          DailyStatRow,
          PrefetchHooks Function()
        > {
  $$DailyStatsTableTableManager(_$DatabaseHelper db, $DailyStatsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyStatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyStatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyStatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<int> newCount = const Value.absent(),
                Value<int> reviewCount = const Value.absent(),
                Value<int> correctCount = const Value.absent(),
                Value<int> graduatedCount = const Value.absent(),
                Value<int> checkedIn = const Value.absent(),
                Value<int?> checkInTime = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyStatsCompanion(
                date: date,
                newCount: newCount,
                reviewCount: reviewCount,
                correctCount: correctCount,
                graduatedCount: graduatedCount,
                checkedIn: checkedIn,
                checkInTime: checkInTime,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                Value<int> newCount = const Value.absent(),
                Value<int> reviewCount = const Value.absent(),
                Value<int> correctCount = const Value.absent(),
                Value<int> graduatedCount = const Value.absent(),
                Value<int> checkedIn = const Value.absent(),
                Value<int?> checkInTime = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyStatsCompanion.insert(
                date: date,
                newCount: newCount,
                reviewCount: reviewCount,
                correctCount: correctCount,
                graduatedCount: graduatedCount,
                checkedIn: checkedIn,
                checkInTime: checkInTime,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyStatsTableProcessedTableManager =
    ProcessedTableManager<
      _$DatabaseHelper,
      $DailyStatsTable,
      DailyStatRow,
      $$DailyStatsTableFilterComposer,
      $$DailyStatsTableOrderingComposer,
      $$DailyStatsTableAnnotationComposer,
      $$DailyStatsTableCreateCompanionBuilder,
      $$DailyStatsTableUpdateCompanionBuilder,
      (
        DailyStatRow,
        BaseReferences<_$DatabaseHelper, $DailyStatsTable, DailyStatRow>,
      ),
      DailyStatRow,
      PrefetchHooks Function()
    >;
typedef $$ReviewEventsTableCreateCompanionBuilder =
    ReviewEventsCompanion Function({
      Value<int> id,
      required String cardId,
      required int reviewedAt,
      required int rating,
      required int correct,
      required int isNew,
      required int graduated,
      Value<String> eventKind,
      required double elapsedDays,
      required double previousDifficulty,
      required double previousStability,
      Value<int?> previousDue,
      required int previousReps,
      required int previousLapses,
      required double nextDifficulty,
      required double nextStability,
      Value<int?> nextDue,
      required int nextReps,
      required int nextLapses,
      Value<int> voided,
      required int createdAt,
    });
typedef $$ReviewEventsTableUpdateCompanionBuilder =
    ReviewEventsCompanion Function({
      Value<int> id,
      Value<String> cardId,
      Value<int> reviewedAt,
      Value<int> rating,
      Value<int> correct,
      Value<int> isNew,
      Value<int> graduated,
      Value<String> eventKind,
      Value<double> elapsedDays,
      Value<double> previousDifficulty,
      Value<double> previousStability,
      Value<int?> previousDue,
      Value<int> previousReps,
      Value<int> previousLapses,
      Value<double> nextDifficulty,
      Value<double> nextStability,
      Value<int?> nextDue,
      Value<int> nextReps,
      Value<int> nextLapses,
      Value<int> voided,
      Value<int> createdAt,
    });

class $$ReviewEventsTableFilterComposer
    extends Composer<_$DatabaseHelper, $ReviewEventsTable> {
  $$ReviewEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isNew => $composableBuilder(
    column: $table.isNew,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get graduated => $composableBuilder(
    column: $table.graduated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventKind => $composableBuilder(
    column: $table.eventKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get elapsedDays => $composableBuilder(
    column: $table.elapsedDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get previousDifficulty => $composableBuilder(
    column: $table.previousDifficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get previousStability => $composableBuilder(
    column: $table.previousStability,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get previousDue => $composableBuilder(
    column: $table.previousDue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get previousReps => $composableBuilder(
    column: $table.previousReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get previousLapses => $composableBuilder(
    column: $table.previousLapses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get nextDifficulty => $composableBuilder(
    column: $table.nextDifficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get nextStability => $composableBuilder(
    column: $table.nextStability,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nextDue => $composableBuilder(
    column: $table.nextDue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nextReps => $composableBuilder(
    column: $table.nextReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nextLapses => $composableBuilder(
    column: $table.nextLapses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get voided => $composableBuilder(
    column: $table.voided,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReviewEventsTableOrderingComposer
    extends Composer<_$DatabaseHelper, $ReviewEventsTable> {
  $$ReviewEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isNew => $composableBuilder(
    column: $table.isNew,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get graduated => $composableBuilder(
    column: $table.graduated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventKind => $composableBuilder(
    column: $table.eventKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get elapsedDays => $composableBuilder(
    column: $table.elapsedDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get previousDifficulty => $composableBuilder(
    column: $table.previousDifficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get previousStability => $composableBuilder(
    column: $table.previousStability,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get previousDue => $composableBuilder(
    column: $table.previousDue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get previousReps => $composableBuilder(
    column: $table.previousReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get previousLapses => $composableBuilder(
    column: $table.previousLapses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get nextDifficulty => $composableBuilder(
    column: $table.nextDifficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get nextStability => $composableBuilder(
    column: $table.nextStability,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nextDue => $composableBuilder(
    column: $table.nextDue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nextReps => $composableBuilder(
    column: $table.nextReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nextLapses => $composableBuilder(
    column: $table.nextLapses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get voided => $composableBuilder(
    column: $table.voided,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReviewEventsTableAnnotationComposer
    extends Composer<_$DatabaseHelper, $ReviewEventsTable> {
  $$ReviewEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => column);

  GeneratedColumn<int> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<int> get correct =>
      $composableBuilder(column: $table.correct, builder: (column) => column);

  GeneratedColumn<int> get isNew =>
      $composableBuilder(column: $table.isNew, builder: (column) => column);

  GeneratedColumn<int> get graduated =>
      $composableBuilder(column: $table.graduated, builder: (column) => column);

  GeneratedColumn<String> get eventKind =>
      $composableBuilder(column: $table.eventKind, builder: (column) => column);

  GeneratedColumn<double> get elapsedDays => $composableBuilder(
    column: $table.elapsedDays,
    builder: (column) => column,
  );

  GeneratedColumn<double> get previousDifficulty => $composableBuilder(
    column: $table.previousDifficulty,
    builder: (column) => column,
  );

  GeneratedColumn<double> get previousStability => $composableBuilder(
    column: $table.previousStability,
    builder: (column) => column,
  );

  GeneratedColumn<int> get previousDue => $composableBuilder(
    column: $table.previousDue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get previousReps => $composableBuilder(
    column: $table.previousReps,
    builder: (column) => column,
  );

  GeneratedColumn<int> get previousLapses => $composableBuilder(
    column: $table.previousLapses,
    builder: (column) => column,
  );

  GeneratedColumn<double> get nextDifficulty => $composableBuilder(
    column: $table.nextDifficulty,
    builder: (column) => column,
  );

  GeneratedColumn<double> get nextStability => $composableBuilder(
    column: $table.nextStability,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nextDue =>
      $composableBuilder(column: $table.nextDue, builder: (column) => column);

  GeneratedColumn<int> get nextReps =>
      $composableBuilder(column: $table.nextReps, builder: (column) => column);

  GeneratedColumn<int> get nextLapses => $composableBuilder(
    column: $table.nextLapses,
    builder: (column) => column,
  );

  GeneratedColumn<int> get voided =>
      $composableBuilder(column: $table.voided, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ReviewEventsTableTableManager
    extends
        RootTableManager<
          _$DatabaseHelper,
          $ReviewEventsTable,
          ReviewEventRow,
          $$ReviewEventsTableFilterComposer,
          $$ReviewEventsTableOrderingComposer,
          $$ReviewEventsTableAnnotationComposer,
          $$ReviewEventsTableCreateCompanionBuilder,
          $$ReviewEventsTableUpdateCompanionBuilder,
          (
            ReviewEventRow,
            BaseReferences<
              _$DatabaseHelper,
              $ReviewEventsTable,
              ReviewEventRow
            >,
          ),
          ReviewEventRow,
          PrefetchHooks Function()
        > {
  $$ReviewEventsTableTableManager(_$DatabaseHelper db, $ReviewEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> cardId = const Value.absent(),
                Value<int> reviewedAt = const Value.absent(),
                Value<int> rating = const Value.absent(),
                Value<int> correct = const Value.absent(),
                Value<int> isNew = const Value.absent(),
                Value<int> graduated = const Value.absent(),
                Value<String> eventKind = const Value.absent(),
                Value<double> elapsedDays = const Value.absent(),
                Value<double> previousDifficulty = const Value.absent(),
                Value<double> previousStability = const Value.absent(),
                Value<int?> previousDue = const Value.absent(),
                Value<int> previousReps = const Value.absent(),
                Value<int> previousLapses = const Value.absent(),
                Value<double> nextDifficulty = const Value.absent(),
                Value<double> nextStability = const Value.absent(),
                Value<int?> nextDue = const Value.absent(),
                Value<int> nextReps = const Value.absent(),
                Value<int> nextLapses = const Value.absent(),
                Value<int> voided = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
              }) => ReviewEventsCompanion(
                id: id,
                cardId: cardId,
                reviewedAt: reviewedAt,
                rating: rating,
                correct: correct,
                isNew: isNew,
                graduated: graduated,
                eventKind: eventKind,
                elapsedDays: elapsedDays,
                previousDifficulty: previousDifficulty,
                previousStability: previousStability,
                previousDue: previousDue,
                previousReps: previousReps,
                previousLapses: previousLapses,
                nextDifficulty: nextDifficulty,
                nextStability: nextStability,
                nextDue: nextDue,
                nextReps: nextReps,
                nextLapses: nextLapses,
                voided: voided,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String cardId,
                required int reviewedAt,
                required int rating,
                required int correct,
                required int isNew,
                required int graduated,
                Value<String> eventKind = const Value.absent(),
                required double elapsedDays,
                required double previousDifficulty,
                required double previousStability,
                Value<int?> previousDue = const Value.absent(),
                required int previousReps,
                required int previousLapses,
                required double nextDifficulty,
                required double nextStability,
                Value<int?> nextDue = const Value.absent(),
                required int nextReps,
                required int nextLapses,
                Value<int> voided = const Value.absent(),
                required int createdAt,
              }) => ReviewEventsCompanion.insert(
                id: id,
                cardId: cardId,
                reviewedAt: reviewedAt,
                rating: rating,
                correct: correct,
                isNew: isNew,
                graduated: graduated,
                eventKind: eventKind,
                elapsedDays: elapsedDays,
                previousDifficulty: previousDifficulty,
                previousStability: previousStability,
                previousDue: previousDue,
                previousReps: previousReps,
                previousLapses: previousLapses,
                nextDifficulty: nextDifficulty,
                nextStability: nextStability,
                nextDue: nextDue,
                nextReps: nextReps,
                nextLapses: nextLapses,
                voided: voided,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReviewEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$DatabaseHelper,
      $ReviewEventsTable,
      ReviewEventRow,
      $$ReviewEventsTableFilterComposer,
      $$ReviewEventsTableOrderingComposer,
      $$ReviewEventsTableAnnotationComposer,
      $$ReviewEventsTableCreateCompanionBuilder,
      $$ReviewEventsTableUpdateCompanionBuilder,
      (
        ReviewEventRow,
        BaseReferences<_$DatabaseHelper, $ReviewEventsTable, ReviewEventRow>,
      ),
      ReviewEventRow,
      PrefetchHooks Function()
    >;

class $DatabaseHelperManager {
  final _$DatabaseHelper _db;
  $DatabaseHelperManager(this._db);
  $$QuestionsTableTableManager get questions =>
      $$QuestionsTableTableManager(_db, _db.questions);
  $$CardsTableTableManager get cards =>
      $$CardsTableTableManager(_db, _db.cards);
  $$MetaEntriesTableTableManager get metaEntries =>
      $$MetaEntriesTableTableManager(_db, _db.metaEntries);
  $$DailyStatsTableTableManager get dailyStats =>
      $$DailyStatsTableTableManager(_db, _db.dailyStats);
  $$ReviewEventsTableTableManager get reviewEvents =>
      $$ReviewEventsTableTableManager(_db, _db.reviewEvents);
}
