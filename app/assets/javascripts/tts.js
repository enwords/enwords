var voiceByLang = {
  "eng": "Daniel",
  "ita": "Luca",
  "fra": "Thomas",
  "deu": "Anna",
  "rus": "Yuri",
  "spa": "Juan",
  "pol": "Zosia",
  "nld": "Xander",
  "fin": "Satu",
  "zho": "Ting-Ting",
  "por": "Joana",
  "ara": "Maged",
  "heb": "Carmit",
  "swe": "Alva",
  "ind": "Damayanti",
  "rom": "Ioana",
  "hun": "Mariska",
  "jap": "Kyoko",
  "dan": "Sara",
  "tha": "Kanya",
  "gre": "Melina",
  "kor": "Yuna",
  "ces": "Zuzana",
  "tur": "Yelda",
  "nob": "Nora",
  "hin": "Lekha",
  "slo": "Laura",
}


function tts(text, lang) {
  var synth = window.speechSynthesis;
  getVoice(voiceByLang[lang], synth).then(function(voice) {
    var utterThis = new SpeechSynthesisUtterance(text);
    utterThis.voice = voice;
    synth.speak(utterThis);
  })
}

function getVoice(voiceName, synth) {
  return new Promise(function(resolve, reject) {
    synth.onvoiceschanged = function () { findVoice(voiceName, synth, resolve) }
    findVoice(voiceName, synth, resolve)
    synth.getVoices();
  });
}

function findVoice(voiceName, synth, resolve) {
  var voices = synth.getVoices();
  for (var i = 0; i < voices.length; i++) {
    if(voices[i].name === voiceName) {
      resolve(voices[i]);
    }
  }
}
