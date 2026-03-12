package net.brown_bakers.bakers_transfurs.init;

import com.mojang.datafixers.util.Pair;

import net.brown_bakers.bakers_transfurs.BakersTransfurs;

import net.brown_bakers.bakers_transfurs.entity.LatexCheetahFemale;
import net.brown_bakers.bakers_transfurs.entity.LatexCheetahMale;
import net.brown_bakers.bakers_transfurs.entity.LatexFox;
import net.ltxprogrammer.changed.entity.ChangedEntity;
import net.ltxprogrammer.changed.init.ChangedEntities;

import net.minecraft.world.entity.EntityType;
import net.minecraft.world.entity.ai.attributes.AttributeSupplier;
import net.minecraft.world.level.Level;

import net.minecraftforge.api.distmarker.Dist;
import net.minecraftforge.event.entity.EntityAttributeCreationEvent;
import net.minecraftforge.eventbus.api.SubscribeEvent;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.event.lifecycle.FMLCommonSetupEvent;
import net.minecraftforge.registries.DeferredRegister;
import net.minecraftforge.registries.ForgeRegistries;
import net.minecraftforge.registries.RegistryObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Predicate;
import java.util.function.Supplier;

@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD, value = Dist.CLIENT)
public class InitEntities
{
	//Global Entity registry
	public static final DeferredRegister<EntityType<?>> ENTITY_REGISTRY = DeferredRegister.create(ForgeRegistries.ENTITY_TYPES, BakersTransfurs.MODID);
	public static final HashMap<String, Pair<Integer, Integer>> ENTITY_COLORS = new HashMap<>();
	public static final List<ChangedEntities.VoidConsumer> INIT_FUNCTIONS = new ArrayList<>();
	public static final List<Pair<Supplier<EntityType<? extends ChangedEntity>>, Supplier<AttributeSupplier.Builder>>> INIT_ATTRIBS = new ArrayList<>();
	public static final Map<Supplier<? extends EntityType<?>>, Predicate<Level>> DIMENSION_RESTRICTIONS = new HashMap<>();
	
	public static final RegistryObject<EntityType<LatexFox>> LATEX_FOX = LatexFox.getEntityInitRObject();
	public static final RegistryObject<EntityType<LatexCheetahMale>> LATEX_CHEETAH_MALE = LatexCheetahMale.getEntityInitRObject();
	public static final RegistryObject<EntityType<LatexCheetahFemale>> LATEX_CHEETAH_FEMALE = LatexCheetahFemale.getEntityInitRObject();
	
	@SubscribeEvent
	public static void init(FMLCommonSetupEvent event) {
		event.enqueueWork( () -> INIT_FUNCTIONS.forEach(ChangedEntities.VoidConsumer::accept) );
	}
	
	@SubscribeEvent
	public static void registerAttributes(EntityAttributeCreationEvent event) {
		INIT_ATTRIBS.forEach((pair) -> event.put(pair.getFirst().get(), pair.getSecond().get().build()));
	}
	

	
}
