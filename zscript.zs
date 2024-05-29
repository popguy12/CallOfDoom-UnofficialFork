version 4.5

//PB Player
#include "zscript/Player/PB_PlayerPawn.zs"
#include "zscript/Player/PB_Player.zs"

//PB Weapons
#include "zscript/Weapons/BaseWeapon.zs"
#include "zscript/Weapons/Slot2/PB_Pistol.zs"

//PB Items
#include "zscript/Items/PowerupsBase.zs"
#include "zscript/Items/AmmoBase.zs"
#include "zscript/Items/HPAPBase.zs"
#include "zscript/Items/PowerUps/Powerups.zs"
#include "zscript/Items/Ammo/AmmoBullet.zs"
#include "zscript/Items/Ammo/AmmoShell.zs"
#include "zscript/Items/Ammo/AmmoExplosive.zs"
#include "zscript/Items/Ammo/AmmoCell.zs"
#include "zscript/Items/Ammo/AmmoFuel.zs"
#include "zscript/Items/Ammo/AmmoDemon.zs"
#include "zscript/Items/Ammo/AmmoPacks.zs"
#include "zscript/Items/HealthArmor/HP.zs"
#include "zscript/Items/HealthArmor/AP.zs"

//PB Misc
#include "zscript/MathNMixins.zs"

//PB Effects
#include "zscript/Effects/Casings.zs"
const STAT_PB_BULLETS = Thinker.STAT_USER_MAX - 1;
#include "zscript/Effects/Smoke.zs"

//PB Projectiles
#include "zscript/Weapons/Projectiles/BulletProjectile.zs"
#include "zscript/Weapons/Projectiles/BulletDef.SmallCal.zs"
#include "zscript/Weapons/Projectiles/BulletDef.Shell.zs"
#include "zscript/Weapons/Projectiles/BulletDef.HighCal.zs"
#include "zscript/Weapons/Projectiles/BulletDef.SpecialProjectiles.zs"

//PB Monsters
#include "zscript/Monsters/PBMonster.zs"
