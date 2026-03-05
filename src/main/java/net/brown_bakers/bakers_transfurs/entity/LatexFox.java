package net.brown_bakers.bakers_transfurs.entity;

import net.brown_bakers.bakers_transfurs.init.IEntityInit;
import net.brown_bakers.bakers_transfurs.init.InitUtils;
import net.ltxprogrammer.changed.entity.*;
import net.ltxprogrammer.changed.entity.latex.LatexType;
import net.ltxprogrammer.changed.entity.variant.TransfurVariant;
import net.ltxprogrammer.changed.init.*;

import net.minecraft.world.entity.EntityType;
import net.minecraft.world.entity.MobCategory;
import net.minecraft.world.entity.SpawnPlacements;
import net.minecraft.world.entity.ai.attributes.AttributeMap;
import net.minecraft.world.entity.ai.attributes.AttributeSupplier;
import net.minecraft.world.entity.ai.attributes.Attributes;
import net.minecraft.world.level.Level;
import net.minecraftforge.registries.RegistryObject;


import static net.brown_bakers.bakers_transfurs.init.InitEntities.LATEX_FOX;


public class LatexFox extends ChangedEntity implements IEntityInit
{
	
	public static EntityType.Builder<LatexFox> getEntityInitBuilder() {
		return EntityType.Builder
			   .of(LatexFox::new, MobCategory.MONSTER)
			   .clientTrackingRange(10)
			   .sized(0.7F, 1.93F);
	}
	
	public static RegistryObject<EntityType<LatexFox>> getEntityInitRObject() {
		return InitUtils.getEntityInitRObject(
			   "latex_fox",
			   0x624f13,
			   0xb4a165,
			   LatexFox.getEntityInitBuilder(),
			   ChangedEntities::overworldOnly,
			   SpawnPlacements.Type.ON_GROUND,
			   LatexFox::checkEntitySpawnRules,
			   ChangedEntity::createLatexAttributes
		);
	}
	
	public static TransfurVariant<LatexFox> getTFInitBuilder()
	{
		return TransfurVariant.Builder
			   .of(LATEX_FOX)
			   .breatheMode(TransfurVariant.BreatheMode.NORMAL)
			   .glide(false)
			   .extraJumps(0)
			   .canClimb(false)
			   .visionType(VisionType.NORMAL)
			   .miningStrength(MiningStrength.NORMAL)
			   .itemUseMode(UseItemMode.NORMAL)
			   //.scares(AbstractVillager.class)
			   .transfurMode(TransfurMode.REPLICATION)
			   .addAbility(ChangedAbilities.SWITCH_TRANSFUR_MODE)
			   .addAbility(ChangedAbilities.GRAB_ENTITY_ABILITY)
			   .cameraZOffset(0.0f)
			   .sound(ChangedSounds.TRANSFUR_BY_LATEX.getId())
			   .build();
	}
	
	public LatexFox(EntityType<? extends ChangedEntity> type, Level level) { super(type, level); }
	
	@Override
	public TransfurMode getTransfurMode() {
		return TransfurMode.REPLICATION;
	}
	
	@Override	//redundant - Changed Entity defaults to none.
	public LatexType getLatexType() { return ChangedLatexTypes.NONE.get(); }
	
	@Override
	protected void setAttributes (AttributeMap attributes) {
		super.setAttributes(attributes);
		attributes.getInstance(Attributes.MOVEMENT_SPEED).setBaseValue(1.05);
		attributes.getInstance(ChangedAttributes.SNEAK_SPEED.get()).setBaseValue(1.5D);
		attributes.getInstance(ChangedAttributes.JUMP_STRENGTH.get()).setBaseValue(1.5);
		attributes.getInstance(ChangedAttributes.FALL_RESISTANCE.get()).setBaseValue(1.25);
	}
}