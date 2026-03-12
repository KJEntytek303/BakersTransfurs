package net.brown_bakers.bakers_transfurs.entity;

import net.ltxprogrammer.changed.entity.*;
import net.ltxprogrammer.changed.entity.latex.LatexType;
import net.ltxprogrammer.changed.init.ChangedAttributes;
import net.ltxprogrammer.changed.init.ChangedLatexTypes;
import net.ltxprogrammer.changed.util.Color3;
import net.minecraft.world.entity.EntityType;
import net.minecraft.world.entity.ai.attributes.AttributeMap;
import net.minecraft.world.entity.ai.attributes.Attributes;
import net.minecraft.world.level.Level;
import net.minecraftforge.common.ForgeMod;

public abstract class AbstractLatexCheetah extends ChangedEntity implements GenderedEntity {
	
	
	public AbstractLatexCheetah(EntityType<? extends ChangedEntity> type, Level level) {
		super(type, level);
	}
	
	@Override
	public TransfurMode getTransfurMode() {
		return TransfurMode.REPLICATION;
	}
	
	@Override	//redundant - Changed Entity defaults to none.
	public LatexType getLatexType() { return ChangedLatexTypes.NONE.get(); }
	
	@Override
	public Color3 getTransfurColor(TransfurCause cause) {
		return Color3.fromInt(0xf2d882);
	}
	
	@Override
	public int getTicksRequiredToFreeze() { return 200; }
	
	@Override
	protected void setAttributes (AttributeMap attributes) {
		super.setAttributes(attributes);
		attributes.getInstance(Attributes.MOVEMENT_SPEED).setBaseValue(1.35);
		attributes.getInstance(ForgeMod.SWIM_SPEED.get()).setBaseValue(0.86);
		attributes.getInstance(ChangedAttributes.AIR_CAPACITY.get()).setBaseValue(7.5);
		attributes.getInstance(ChangedAttributes.SPRINT_SPEED.get()).setBaseValue(1.05);
		attributes.getInstance(ChangedAttributes.JUMP_STRENGTH.get()).setBaseValue(1.5);
		attributes.getInstance(ChangedAttributes.FALL_RESISTANCE.get()).setBaseValue(1.5);
	}
}
