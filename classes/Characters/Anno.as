﻿package classes.Characters
{
	import classes.Creature;
	import classes.GLOBAL;
	import classes.Items.Guns.HammerCarbine;
	import classes.Items.Guns.LaserCarbine;
	import classes.Items.Guns.Goovolver;
	import classes.Items.Guns.ZKRifle;
	
	public class Anno extends Creature
	{
		//constructor
		public function Anno()
		{
			this._latestVersion = 1;
			this.version = this._latestVersion;
			this._neverSerialize = true;
			
			this.inventory.push(new HammerCarbine());
			this.inventory.push(new LaserCarbine());
			this.inventory.push(new Goovolver());
			this.inventory.push(new ZKRifle());
			
			this.typesBought[this.typesBought.length] = GLOBAL.ARMOR;
			this.typesBought[this.typesBought.length] = GLOBAL.RANGED_WEAPON;
			this.typesBought[this.typesBought.length] = GLOBAL.SHIELD;
			this.sellMarkup = 1.1;
			this.buyMarkdown = .85;

			this.short = "Anno";
			this.originalRace = "ausar";
			this.a = "";
			this.capitalA = "";
			this.long = "Placeholder";
			this.customDodge = "Anno Don't Dodge Foo";
			this.customBlock = "Obvious placeholder is obvious.";
			this.plural = false;
			this.lustVuln = 1;
			
			this.meleeWeapon.attackVerb = "punch";
			this.meleeWeapon.longName = "fist";
			this.meleeWeapon.hasRandomProperties = true;
			
			this.armor.longName = "coat";
			this.armor.defense = 1;
			this.armor.hasRandomProperties = true;
			
			this.physiqueRaw = 8;
			this.reflexesRaw = 10;
			this.aimRaw = 17;
			this.intelligenceRaw = 19;
			this.willpowerRaw = 14;
			this.libidoRaw = 55;
			this.HPMod = 15;
			this.shieldsRaw = this.shieldsMax();
			this.HPRaw = this.HPMax();
			this.energyRaw = 100;
			this.lustRaw = 15;
			this.resistances = new Array(1,1,1,1,1,1,1,1);
			this.XPRaw = 350;
			this.level = 4;
			this.credits = 0;
			
			this.femininity = 80;
			this.eyeType = 0;
			this.eyeColor = "blue";
			this.tallness = 70;
			this.thickness = 40;
			this.tone = 0;
			this.hairColor = "white";
			this.scaleColor = "ebony";
			this.furColor = "white";
			this.hairLength = 32;
			this.hairType = 0;
			this.beardLength = 0;
			this.beardStyle = 0;
			this.skinType = GLOBAL.FUR;
			this.skinTone = "pale";
			this.skinFlags = [GLOBAL.FLUFFY];
			this.faceType = 0;
			this.faceFlags = new Array();
			this.tongueType = 0;
			this.lipMod = 2;
			this.earType = GLOBAL.CANINE;
			this.antennae = 0;
			this.antennaeType = 0;
			this.horns = 0;
			this.hornType = 0;
			this.armType = GLOBAL.CANINE;
			this.gills = false;
			this.wingType = 0;
			this.legType = GLOBAL.CANINE;
			this.legCount = 2;
			this.legFlags = [GLOBAL.PLANTIGRADE];
			//0 - Waist
			//1 - Middle of a long tail. Defaults to waist on bipeds.
			//2 - Between last legs or at end of long tail.
			//3 - On underside of a tail, used for driders and the like, maybe?
			this.genitalSpot = 0;
			this.tailType = GLOBAL.CANINE;
			this.tailCount = 1;
			this.tailFlags = [GLOBAL.FLUFFY];
			//Used to set cunt or dick type for cunt/dick tails!
			this.tailGenitalArg = 0;
			//tailGenital:
			//0 - none.
			//1 - cock
			//2 - vagina
			this.tailGenital = 0;
			//Tail venom is a 0-100 slider used for tail attacks. Recharges per hour.
			this.tailVenom = 0;
			//Tail recharge determines how fast venom/webs comes back per hour.
			this.tailRecharge = 5;
			//hipRating
			//0 - boyish
			//2 - slender
			//4 - average
			//6 - noticable/ample
			//10 - curvy//flaring
			//15 - child-bearing/fertile
			//20 - inhumanly wide
			this.hipRatingRaw = 10;
			//buttRating
			//0 - buttless
			//2 - tight
			//4 - average
			//6 - noticable
			//8 - large
			//10 - jiggly
			//13 - expansive
			//16 - huge
			//20 - inconceivably large/big/huge etc
			this.buttRatingRaw = 9;
			//No dicks here!
			this.cocks = new Array();
			//balls
			this.balls = 2;
			this.cumMultiplierRaw = 3;
			//Multiplicative value used for impregnation odds. 0 is infertile. Higher is better.
			this.cumQualityRaw = 1;
			this.cumType = GLOBAL.CUM;
			this.ballSizeRaw = 2;
			this.ballFullness = 100;
			//How many "normal" orgams worth of jizz your balls can hold.
			this.ballEfficiency = 15;
			//Scales from 0 (never produce more) to infinity.
			this.refractoryRate = 9999;
			this.minutesSinceCum = 65;
			this.timesCum = 9001;
			this.cockVirgin = false;
			this.vaginalVirgin = false;
			this.analVirgin = false;
			//Goo is hyper friendly!
			this.elasticity = 1.5;
			//Fertility is a % out of 100. 
			this.fertilityRaw = 1.05;
			this.clitLength = .5;
			this.pregnancyMultiplierRaw = 1;
			
			this.breastRows[0].breastRatingRaw = 5;
			this.nippleColor = "pink";
			this.milkMultiplier = 0;
			this.milkType = GLOBAL.MILK;
			//The rate at which you produce milk. Scales from 0 to INFINITY.
			this.milkRate = 0;
			this.ass.wetnessRaw = 0;
			this.ass.loosenessRaw = 1;
			this.createVagina();
			this.vaginas[0].wetnessRaw = 2;
			this.vaginas[0].loosenessRaw = 1;
			
			this._isLoading = false;
		}		
	}
}