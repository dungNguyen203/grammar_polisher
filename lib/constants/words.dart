import '../data/models/word.dart';

class Words {
  static const _sampleWordJson = {
    "index": 0,
    "word": "sample",
    "pos": "noun",
    "phonetic": "https://www.oxfordlearnersdictionaries.com/media/english/uk_pron/s/sam/sampl/sample__gb_3.mp3",
    "phonetic_text": "/ˈsɑːmpl/",
    "phonetic_am": "https://www.oxfordlearnersdictionaries.com/media/english/us_pron/s/sam/sampl/sample__us_1.mp3",
    "phonetic_am_text": "/ˈsæmpl/",
    "senses": [
      {
        "definition":
            "a number of people or things taken from a larger group and used in tests to provide information about the group",
        "examples": [
          {"cf": "", "x": "The interviews were given to a random sample of students."},
          {"cf": "", "x": "The survey covers a representative sample of schools."},
          {"cf": "", "x": "a sample survey"},
          {"cf": "", "x": "The current study has a larger sample size than earlier studies."},
          {"cf": "", "x": "We studied a large population sample."}
        ]
      },
      {
        "definition":
            "a small amount of a substance taken from a larger amount and tested in order to obtain information about the substance",
        "examples": [
          {"cf": "", "x": "a blood/urine/tissue/DNA sample"},
          {"cf": "sample of something", "x": "Samples of the water contained pesticide."},
          {"cf": "", "x": "A small sample of blood must be tested by a doctor."},
          {"cf": "", "x": "to collect/obtain/take a sample"},
          {"cf": "", "x": "We analyzed samples from more than a dozen common tree species. "},
          {"cf": "", "x": "Her sample contained traces of the banned steroid."}
        ]
      },
      {
        "definition": "a small amount or example of something that can be looked at or tried to see what it is like",
        "examples": [
          {"cf": "", "x": "‘I'd like to see a sample of your work,’ said the manager."},
          {"cf": "", "x": "a free sample of shampoo"},
          {"cf": "", "x": "Would you like a sample of the fabric to take home?"},
          {"cf": "", "x": "We looked at sample books to choose the fabric."}
        ]
      },
      {
        "definition": "a piece of recorded music or sound that is used in a new piece of music",
        "examples": [
          {"cf": "", "x": "‘Candy’ includes a swirling sample from a Walker Brothers song."}
        ]
      }
    ]
  };

  static const _helloWordJson = {
    "index": 1,
    "word": "hello",
    "pos": "exclamation, noun",
    "phonetic": "https://www.oxfordlearnersdictionaries.com/media/english/uk_pron/h/hel/hello/hello__gb_1.mp3",
    "phonetic_text": "/həˈləʊ/",
    "phonetic_am": "https://www.oxfordlearnersdictionaries.com/media/english/us_pron/h/hel/hello/hello__us_1_rr.mp3",
    "phonetic_am_text": "/həˈləʊ/",
    "senses": [
      {
        "definition": "used as a greeting when you meet somebody, in an email, when you answer the phone or when you want to attract somebody’s attention",
        "examples": [
          {
            "cf": "",
            "x": "Hello John, how are you?"
          },
          {
            "cf": "",
            "x": "Hello, is there anybody there?"
          },
          {
            "cf": "",
            "x": "Say hello to Liz for me."
          },
          {
            "cf": "",
            "x": "They exchanged hellos (= said hello to each other) and forced smiles."
          }
        ]
      },
      {
        "definition": "used to show that you are surprised by something",
        "examples": [
          {
            "cf": "",
            "x": "Hello, hello, what's going on here?"
          }
        ]
      },
      {
        "definition": "used to show that you think somebody has said something stupid or is not paying attention",
        "examples": [
          {
            "cf": "",
            "x": "Hello? You didn't really mean that, did you?"
          },
          {
            "cf": "",
            "x": "I'm like, ‘Hello! Did you even listen?’"
          }
        ]
      }
    ]
  };

  static final sampleWord = Word.fromJson(_sampleWordJson);
  static final helloWord = Word.fromJson(_helloWordJson);
}
