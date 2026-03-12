package net.brown_bakers.bakers_transfurs.init;

import net.brown_bakers.bakers_transfurs.client.renderer.model.LatexCheetahFemaleModel;
import net.brown_bakers.bakers_transfurs.client.renderer.model.LatexCheetahMaleModel;
import net.brown_bakers.bakers_transfurs.client.renderer.model.LatexFoxModel;
import net.minecraftforge.api.distmarker.Dist;
import net.minecraftforge.client.event.EntityRenderersEvent;
import net.minecraftforge.eventbus.api.SubscribeEvent;
import net.minecraftforge.fml.common.Mod;

@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD, value = Dist.CLIENT)
public class InitLayerDefinitions {
	
	@SubscribeEvent
	public static void registerLayerDefinitions(EntityRenderersEvent.RegisterLayerDefinitions event) {
		event.registerLayerDefinition(LatexFoxModel.LAYER_LOCATION, LatexFoxModel::createBodyLayer);
		event.registerLayerDefinition(LatexCheetahMaleModel.LAYER_LOCATION, LatexCheetahMaleModel::createBodyLayer);
		event.registerLayerDefinition(LatexCheetahFemaleModel.LAYER_LOCATION, LatexCheetahFemaleModel::createBodyLayer);
	}
	
}