import 'dart:convert';

import 'package:meta/meta.dart';

import '../../shared.dart';

class LocalLoadFavoriteLyrics implements LoadFavoriteLyrics {
  final LoadLocalStorage loadLocalStorage;

  LocalLoadFavoriteLyrics({@required this.loadLocalStorage});

  @override
  Future<List<LyricEntity>> loadFavorites() async {
    try {
      var favorites = await loadLocalStorage.load('favorites');

      // Temporary...
      if (favorites == null || favorites.isEmpty) {
        favorites = _fakeData();
      }

      if (favorites?.isNotEmpty == true) {
        List favoriteMapList = jsonDecode(favorites);

        return favoriteMapList
            .map((entity) => LocalLyricModel.fromMap(entity).toEntity())
            .toList();
      }

      return null;
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  _fakeData() {
    return jsonEncode([
      {
        "artist": "eric clapton",
        "music": "tears in heaven",
        "lyric":
            "Would you know my name\r\nif I saw you in heaven?\r\nWould it be the same\r\nIf I saw you in heaven?\r\nI must be strong \n\nand carry on.\n\n'Cause I know I don't belong \n\nhere in heaven.\n\n\n\nWould you hold my hand\n\nIf I saw you in heaven?\n\nWould you help me stand\n\nIf I saw you in heaven?\n\n\n\nI'll find my way \n\nthrough night and day.\n\n'Cause I know I just can't stay \n\nhere in heaven.\n\n\n\nTime can bring you down\n\nTime can bend your knees.\n\nTime can break your heart\n\nHave you begging please.\n\nBegging please...\n\n\n\nBeyond the door \n\nthere's peace, I'm sure.\n\nAnd I know there'll be no more \n\ntears in heaven.\n\n\n\nWould you know my name\n\nif I saw you in heaven?\n\nWould it be the same\n\nIf I saw you in heaven?\n\n\n\nI must be strong \n\nand carry on.\n\n'Cause I know I don't belong \n\nhere in heaven\n\n'Cause I know I don't belong \n\nhere in heaven"
      },
      {
        "artist": "metallica",
        "music": "enter sandman ",
        "lyric":
            "Say your prayers, little one\r\nDon't forget, my son, \nTo include everyone \nTuck you in, warm within \nKeep you free from sin \n\nTill the sandman he comes \n\n\n\nSleep with one eye open \n\nGripping your pillow tight \n\n\n\nExit: light \n\nEnter: night \n\nTake my hand \n\nWe're off to never-never land \n\n\n\nSomething's wrong, shut the light \n\nHeavy thoughts tonight \n\nAnd they aren't of Snow White \n\n\n\nDreams of war, dreams of liars \n\nDreams of dragon's fire \n\nAnd of things that will bite \n\n\n\nSleep with one eye open \n\nGripping your pillow tight \n\n\n\nExit: light \n\nEnter: night \n\nTake my hand \n\nWe're off to never-never land \n\n\n\nNow I lay me down to sleep \n\nPray the Lord my soul to keep \n\nIf I die before I wake \n\nPray the Lord my soul to take \n\n\n\nHush little baby, don't say a word \n\nAnd never mind that noise you heard \n\nIt's just the beasts under your bed \n\nIn your closet, in your head \n\n\n\nExit: light \n\nEnter: night \n\nGrain of sand \n\n\n\nExit: light \n\nEnter: night \n\nTake my hand \n\nWe're off to never-never land"
      },
      {
        "artist": "metallica",
        "music": "one",
        "lyric":
            "I can't remember anything\r\nCan't tell if this is true or dream \nDeep down inside I feel to scream \nThis terrible silence stops me \nNow that the war is through with me \n\nI'm waking up, I cannot see \n\nThat there is not much left of me \n\nNothing is real but pain now \n\n\n\nHold my breath as I wish for death \n\nOh please, God, wake me \n\n\n\nBack in the womb it's much \n\ntoo real \n\nIn pumps life that I must feel \n\nBut can't look forward to reveal \n\nLook to the time when I'll live \n\n\n\nFed through the tube that sticks in me \n\nJust like a wartime novelty \n\nTied to machines that make me be \n\nCut this life off from me \n\n\n\nHold my breath as I wish for death \n\nOh please, God, wake me \n\n\n\nNow the world is gone, I'm just one \n\nOh God, help me \n\nHold my breath as I wish for death \n\nOh please, God, help me \n\n\n\nDarkness imprisoning me \n\nAll that I see \n\nAbsolute horror \n\nI cannot live \n\nI cannot die \n\nTrapped in myself \n\nBody my holding cell \n\n\n\nLandmine has taken my sight \n\nTaken my speech \n\nTaken my hearing \n\nTaken my arms \n\nTaken my legs \n\nTaken my soul \n\nLeft me with life in hell"
      },
      {
        "artist": "metallica",
        "music": "fuel ",
        "lyric":
            "Gimme fuel, gimme fire\r\nGimme that which I desire\r\nTurn on, I see red \nAdrenaline crash and crack my head \nNitro junkie, paint me dead \n\nAnd I see red \n\n\n\nOne hundred plus through black and white \n\nWar horse, warhead \n\nFuck 'em, man, white-knuckle tight \n\nThrough black and white \n\n\n\nOn I burn\n\nFuel is pumping engines\n\nBurning hard, loose and clean \n\nAnd on I burn\n\nChurning my direction\n\nQuench my thirst with gasoline \n\n\n\nSo gimme fuel, gimme fire\n\nGimme that which I desire\n\n\n\nTurn on beyond the bone \n\nSwallow future, spit out home \n\nBurn your face upon the chrome \n\n\n\nTake the corner, join the crash, \n\nHeadlights, head on, headlines \n\nAnother junkie lives too fast \n\nLives way too fast\n\n\n\nOn I burn \n\nFuel is pumping engines \n\nBurning hard, loose and clean \n\nAnd on I burn \n\nChurning my direction\n\nQuench my thirst with gasoline \n\n\n\nSo gimme fuel, gimme fire\n\nGimme that which I desire\n\n\n\nWhite-knuckle tight\n\n\n\nGimme fuel \n\nGimme fire \n\nMy desire \n\n\n\nOn I burn \n\nFuel is pumping engines \n\nBurning hard, loose and clean \n\nAnd on I burn \n\nChurning my direction \n\nQuench my thirst with gasoline \n\n\n\nGimme fuel, gimme fire\n\nGimme that which I desire\n\n\n\nOn I burn"
      },
      {
        "artist": "eric clapton",
        "music": "layla",
        "lyric":
            "What'll you do when you get lonely\r\nAnd nobody's waiting by your side?\r\nYou've been running and hiding much too long.\r\nYou know it's just your foolish pride.\r\nLayla, you've got me on my knees.\n\nLayla, I'm begging, darling please.\n\nLayla, darling won't you ease my worried mind.\n\n\n\nI tried to give you consolation\n\nWhen your old man had let you down.\n\nLike a fool, I fell in love with you,\n\nTurned my whole world upside down.\n\n\n\nChorus\n\n\n\nLet's make the best of the situation\n\nBefore I finally go insane.\n\nPlease don't say we'll never find a way\n\nAnd tell me all my love's in vain.\n\n\n\nChorus\n\n\n\nChorus"
      },
      {
        "artist": "megadeth",
        "music": "kill the king",
        "lyric":
            "[Dave Mustaine] \nBroken down, feeling naked \nLeaving me unfulfilled \nPromising compromise \nChampioning mediocrity \n\n\n\nTime and time again \n\nWhat you said ain't what you mean \n\nEven if all my bones are broken \n\nI will drag myself back from the edge to \n\n\n\nKill the King, The King is dead, Long live the King \n\n\n\nKill the King, The King is dead, Long live the \n\nKing, \n\nI am the King, God save the King \n\n\n\nKill the King, The King is dead \n\nI am the King, Long live the King \n\nKill the King, The King is dead \n\nI am the King, Long live the King \n\n\n\nI reveal a deceiver \n\nIn the highest seat in the land \n\nHis idle hands the Devil's workshop \n\nGenerate more smoke than heat \n\n\n\nTime and time again \n\nWhat you said ain't what you mean \n\nEven if all my bones are broken \n\nI will drag myself back from the edge to \n\n\n\nKill the King, The King is dead, Long live the King \n\n\n\nKill the King, The King is dead, Long live the \n\nKing, \n\nI am the King, God save the King \n\n\n\nKill the King, The King is dead \n\nI am the King, Long live the King \n\nKill the King, The King is dead \n\nI am the King, Long live the King \n\n\n\nA new precedent in pain, a new precedent in pain \n\nMankind is blown to dust, mankind is blown to dust \n\nAn explosion of the Brain, an explosion of the \n\nBrain \n\nSpontaneously combust, spontaneously combust \n\n\n\nKill the King, The King is dead, Long live the \n\nKing, \n\nI am the King \n\nKill the King, I, The King is dead, I am, Long live \n\nthe King, \n\nI am the King \n\nKill the King, I, The King is dead, I am, Long live \n\nthe King, \n\nI am the King \n\nKill the King, I, The King is dead, I am, Long live \n\nthe King, \n\nI am the King"
      },
      {
        "artist": "megadeth",
        "music": "she wolf",
        "lyric":
            "The mother of all that is evil\r\nher lips are poisonous venom\r\nWicked temptress knows how to please\r\nThe priestess roars, \"get down on your knees\"\r\nThe rite of the praying mantis\n\nKiss the bones of the enchantress\n\nSpellbound searching through the night\n\nA howling man surrenders the fight\n\n\n\nOne look in her lusting eyes\n\nSavage fear in you will rise\n\nTeeth of terror sinking in\n\nThe bite of the she-wolf\n\n\n\nMy desires of flesh obey me\n\nThe lioness will enslave me\n\nAnother heartbeat than my own\n\nSound of claws on cobblestone\n\n\n\nBeware what stalks you in the night\n\nBeware the she-wolf and her bite\n\nher mystic lips tell only lies\n\nher hidden will to kill in disguise"
      },
      {
        "artist": "megadeth",
        "music": "Washington is next",
        "lyric":
            "The quiet war has begun with silent weapons\r\nAnd the new slavery is to keep the people\r\nPoor and stupid, \"Novus Ordo Seclorum\"\r\nHow can there be any logic in biological war?\r\nWe all know this is wrong, but the New World Order's\n\nBeating down the door, oh something needs to be done\n\n\n\nThere was a King, an evil King,\n\nWho dreamt the wickedest of dreams\n\nAn ancient mystery, no prophet could interpret\n\nOf seven years of famine, the wolf is at my door\n\nAs predicted years ago, that that was, that is, that is no more\n\n\n\nThe word predicts the future and tells the truth about the past\n\nOf how the world leaders will hail the new Pharaoh\n\nThe eighth false king to the throne: Washington is Next!\n\n\n\nDisengage their minds, sabotage their health\n\nPromote sex and war and violence in the kindergartens\n\nBlame the parents and teachers; it's their fault, \"Annuit Coeptis\"\n\nAttack the church dynamic, attack the family\n\nKeep the public undisciplined 'til nothing left is sacred and\n\nThe \"have-not's\" get hooked and have to go to the \"have's\" just to cop a fix\n\n\n\nI am the King (an evil king),\n\nWho dreams the wickedest of dreams\n\nAn ancient mystery, nobody could interpret\n\nOf seven empires falling, the wolf is at my door\n\nAs predicted years ago, that that was, that is, that is no more\n\n\n\nThe word predicts my future and tells the truth about my past\n\nOf how the world's leaders are waiting to usher in\n\nThe eighth world power of modern Rome: Washington is Next!\n\n\n\nThere was a King, an evil king,\n\nWho dreamt the wickedest of dreams\n\nAn ancient mystery, no prophet could interpret\n\nOf seven empires falling, the wolf is at my door\n\nAs predicted years ago, that that was, that is, that is no more\n\n\n\nI am a King, and I dream the wildest dreams\n\nNobody could interpret\n\nSeven empires falling, the wolf is at my door\n\nOh, that that was, that is, that is no more\n\n\n\nThere's something at my door, some ancient mystery\n\nThe future tells the truth about my past\n\nAnd I'm the eighth false king to the throne\n\nI've got you in my crosshairs, now, ain't that a bitch?\n\n\n\nWashington, you're next!"
      },
      {
        "artist": "pearl jam",
        "music": "black",
        "lyric":
            "Hey...oooh...\r\nSheets of empty canvas\r\nUntouched sheets of clay\r\nWere laid spread out before me\r\nAs her body once did\r\nAll five horizons\n\nRevolved around her soul\n\nAs the earth to the sun\n\nNow the air I tasted and breathed\n\nHas taken a turn\n\nOoh, and all I taught her was, everything\n\nOoh, I know she gave me all, that she wore\n\nAnd now my bitter hands\n\nChafe beneath the clouds\n\nOf what was everything\n\nOh, the pictures have\n\nAll been washed in black\n\nTattooed everything\n\n\n\nI take a walk outside\n\nI'm surrounded by\n\nSome kids at play\n\nI can feel their laughter\n\nSo why do I sear\n\nOh, and twisted thoughts that spin\n\nRound my head\n\nI'm spinning\n\nOh, I'm spinning\n\nHow quick the sun can, drop away...\n\nAnd now my bitter hands\n\nCradle broken glass\n\nOf what was everything\n\nAll the pictures had\n\nAll been washed in black\n\nTattooed everything\n\nAll the love gone bad\n\nTurned my world to black\n\nTattooed all I see\n\nAll that I am\n\nAll that I will be\n\n\n\nI know someday you'll have a beautiful life\n\nI know you'll be a star\n\nIn somebody else's sky\n\nBut why can't it be can't it be mine"
      },
      {
        "artist": "pearl jam",
        "music": "alive",
        "lyric":
            "\"Son,\" she said, \n\"have I got a little story for you\r\nWhat you thought was your daddy\r\nWas nothing but a...\r\nWhile you were sittin' \n\nhome alone at age thirteen\n\nYour real daddy was dyin'\n\nSorry you didn't see him\n\nBut I'm glad we talked\"\n\n\n\nOh, I - I'm still alive\n\nHey, I - Oh, I'm still alive\n\nHey, I - Oh, I'm still alive\n\nHey, ooh\n\n\n\nWhile she walks slowly\n\nAcross a young man's room\n\nShe said, \"I'm ready for you\"\n\nWhy I can't remember anything to this very day\n\n'Cept the look\n\nThe look?\n\nOh, you know where\n\nNow I can't see I just stare\n\n\n\nI... I'm still alive\n\nHey I... But, I'm still alive\n\nHey I... Boy, I'm still alive\n\nHey I... Oh, I'm still alive. Yeah\n\nOoh yeah. Yeah yeah yeah. Oh. Ooh\n\n\n\n\"Is something wrong?\" She said\n\nOf course there is\n\n\"You're still alive.\" She said\n\nOh, and do I deserve to be?\n\nIs that the question?\n\nAnd if so, if so, who answers?\n\nWho answers?\n\n\n\nI... I'm still alive\n\nHey I... But, I'm still alive Yeah\n\nHey I... Boy, I'm still alive Yeah\n\nHey I... Oh, I'm still alive. Yeah\n\n\n\nOoh yeah ooh Ooh\n\nOoh yeah. Yeah yeah yeah"
      },
      {
        "artist": "johnny cash",
        "music": "one",
        "lyric":
            "Is it getting better\r\nOr do you feel the same\r\nWill it make it easier on you now\r\nIf youve got someone to blame\r\nYou said one love\n\nOne life\n\nWhen its one need\n\nIn the night\n\nOne love we get to share it\n\nIt leaves you baby if you dont care for it\n\n\n\nDid i disappoint you\n\nOr leave a bad taste in your mouth\n\nYou act like you never had love\n\nAnd you want me to go without\n\n\n\nWell its too late\n\nTonight\n\nTo drag the past out\n\nInto the light\n\nWe're one but we're not the same\n\nWe get to carry each other\n\nCarry each other\n\nOne\n\n\n\nHave you come here for forgivness\n\nHave you come to raise the dead\n\nHave you come here to play jesus\n\nTo the lepors in your head\n\n\n\nDid i ask too much\n\nMore than a lot\n\nYou gave me nothing now\n\nIts all i got\n\nWe're one but we're not the same\n\nWell we hurt each other and we're doin it again\n\n\n\nYou said love is a temple\n\nLove the higher law\n\nLove is a temple\n\nLove the higher law\n\n\n\nYou ask me to enter\n\nBut then you make me crawl\n\nI cant be holdin on\n\nTo what youve got\n\nWhen all youve got is hurt\n\n\n\nOne love\n\nOne blood\n\nOne life\n\nYouve got to do what you should\n\nOne life with each other\n\nSister\n\nBrothers\n\nOne life but we're not the same\n\nWe get to carry each other\n\nCarry each other\n\nOne"
      },
      {
        "artist": "metallica",
        "music": "fight fire with fire",
        "lyric":
            "Do unto others as they've done to you\r\nBut what the hell is this world coming to? \nBlow the universe into nothingness \nNuclear warfare shall lay us to rest \nFight fire with fire \n\nEnding is near \n\nFight fire with fire \n\nBursting with fear \n\n\n\nWe all shall die \n\nTime is like a fuse, short and burning fast \n\nArmageddon's here, like said in the past \n\n\n\nFight fire with fire \n\nEnding is near \n\nFight fire with fire \n\nBursting with fear \n\n\n\nSoon to fill our lungs, the hot winds of death \n\nThe gods are laughing, so take your last breath \n\n\n\nFight fire with fire \n\nEnding is near \n\nFight fire with fire \n\nBursting with fear \n\n\n\nFight fire with fire\n\n\n\nFight"
      },
      {
        "artist": "metallica",
        "music": "four horsemen",
        "lyric":
            "By the last breath of the fourth winds blow\rBetter raise your ears\rThe sound of hooves knock at your door\rLock up your wife and children now\rIt's time to wield the blade\rFor now you've got some company\rThe horsemen are drawing nearer\rOn the leather steeds they ride\rThey've come to take you life\rOn through the dead of night\rWith the four horsemen ride\rOr choose your fate and die You've been dying since the day you were born\rYou know it has all been planned\rThe quartet of deliverance rides\rA sinner once, a sinner twice\rNo need for confession now\rCause now you have got the fight of your life\rThe horsemen are drawing nearer\rOn the leather steeds they ride\rThey've come to take you life\rOn through the dead of night\rWith the four horsemen ride\rOr choose your fate and die Time\rHas taken its toll on you\rThe lines that crack your face\rFamine\rYour body it has torn through\rWithered in every place\rPestilence\rFor what you have had to endure\rAnd what you have put others through\rDeath\rDeliverance for you for sure\rThere is nothing you can do\rSo gather round young warriors now\rAnd saddle up your steeds\rKilling scores with demon swords\rNow's the death of doers of wrong\rSwing the judgment hammer down\rSafely inside armor, blood, guts, and sweat\rThe horsemen are drawing nearer\rOn the leather steeds they ride\rThey've come to take you life\rOn through the dead of night\rWith the four horsemen ride\rOr choose your fate and die"
      },
      {
        "artist": "acdc",
        "music": "Back in black",
        "lyric":
            "Paroles de la chanson Back In Black par AC/DC\r\nBack in black\nI hit the sack\nI've been too long\nI'm glad to be back\nYes, I'm let loose\nFrom the noose\nThat's kept me hanging about\nI've been looking at the sky\n'Cause it's gettin' me high\nForget the hearse 'cause I never die\nI got nine lives\nCat's eyes\nAbusin' every one of them and running wild\n\n'Cause I'm back\nYes, I'm back\n\r\n\nWell, I'm back\nYes, I'm back\nWell, I'm back, back\nWell, I'm back in black\nYes, I'm back in black\n\nBack in the back\nOf a cadillac\nNumber one with a bullet, I'm a power pack\nYes, I'm in a bang\nWith a gang\nThey've got to catch me if they want me to hang\nCause I'm back on the track\nAnd I'm beatin' the flack\nNobody's gonna get me on another rap\nSo look at me now\nI'm just makin' my play\nDon't try to push your luck, just get out of my way\n\r\n\n\n'Cause I'm back\nYes, I'm back\nWell, I'm back\nYes, I'm back\nWell, I'm back, back\nWell, I'm back in black\nYes, I'm back in black\n\n'Cause I'm back\nYes, I'm back\nWell, I'm back\nYes, I'm back\nWell, I'm back, back\nWell, I'm back in black\nYes, I'm back in black\n\nHooo yeah\n\r\n\nOhh yeah\nYes I am\nOooh yeah, yeah, oh yeah\nBack in now\nWell I'm back, I'm back\nBack, I'm back\nBack, I'm back\nBack, I'm back\nBack, I'm back\nBack\nBack in black\nYes, I'm back in black\nOut of the sight"
      }
    ]);
  }
}
