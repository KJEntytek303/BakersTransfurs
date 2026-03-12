package net.brown_bakers.bakers_transfurs.entity;

import net.brown_bakers.bakers_transfurs.init.InitUtils;
import net.ltxprogrammer.changed.entity.*;
import net.ltxprogrammer.changed.entity.variant.TransfurVariant;
import net.ltxprogrammer.changed.init.ChangedAbilities;
import net.ltxprogrammer.changed.init.ChangedEntities;
import net.ltxprogrammer.changed.init.ChangedSounds;
import net.minecraft.world.entity.EntityType;
import net.minecraft.world.entity.MobCategory;
import net.minecraft.world.entity.SpawnPlacements;
import net.minecraft.world.level.Level;
import net.minecraftforge.registries.RegistryObject;

import static net.brown_bakers.bakers_transfurs.init.InitEntities.LATEX_CHEETAH_MALE;

public class LatexCheetahMale extends AbstractLatexCheetah implements GenderedEntity {
	
	public static EntityType.Builder<LatexCheetahMale> getEntityInitBuilder() {
		return EntityType.Builder
			   .of(LatexCheetahMale::new, MobCategory.MONSTER)
			   .clientTrackingRange(10)
			   .sized(0.7F, 1.93F);
	}
	
	public static RegistryObject<EntityType<LatexCheetahMale>> getEntityInitRObject() {
		return InitUtils.getEntityInitRObject(
			   "latex_cheetah/male",
			   0xf2d882,
			   0xd1b24f,
			   LatexCheetahMale.getEntityInitBuilder(),
			   ChangedEntities::overworldOnly,
			   SpawnPlacements.Type.ON_GROUND,
			   LatexCheetahMale::checkEntitySpawnRules,
			   ChangedEntity::createLatexAttributes
		);
	}
	
	public static TransfurVariant<LatexCheetahMale> getTFInitBuilder()
	{
		return TransfurVariant.Builder
			   .of(LATEX_CHEETAH_MALE)
			   .breatheMode(TransfurVariant.BreatheMode.NORMAL)
			   .glide(false)
			   .extraJumps(0)
			   .canClimb(false)
			   .visionType(VisionType.NIGHT_VISION)
			   .miningStrength(MiningStrength.NORMAL)
			   .itemUseMode(UseItemMode.NORMAL)
			   //.scares(AbstractVillager.class)
			   .transfurMode(TransfurMode.REPLICATION)
			   .addAbility(ChangedAbilities.SWITCH_TRANSFUR_MODE)
			   .addAbility(ChangedAbilities.GRAB_ENTITY_ABILITY)
			   .addAbility(ChangedAbilities.TOGGLE_NIGHT_VISION)
			   .cameraZOffset(0.0f)
			   .sound(ChangedSounds.TRANSFUR_BY_LATEX.getId())
			   .build();
	}
	
	public LatexCheetahMale(EntityType<? extends ChangedEntity> type, Level level) {
		super(type, level);
	}
	
	@Override
	public Gender getGender()
	{
		return Gender.MALE;
	}
}
