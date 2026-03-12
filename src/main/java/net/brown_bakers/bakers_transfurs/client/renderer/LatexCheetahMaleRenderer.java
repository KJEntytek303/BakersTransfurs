package net.brown_bakers.bakers_transfurs.client.renderer;

import net.brown_bakers.bakers_transfurs.BakersTransfurs;
import net.brown_bakers.bakers_transfurs.client.renderer.model.LatexCheetahMaleModel;
import net.brown_bakers.bakers_transfurs.entity.LatexCheetahMale;
import net.ltxprogrammer.changed.client.renderer.AdvancedHumanoidRenderer;
import net.ltxprogrammer.changed.client.renderer.layers.CustomEyesLayer;
import net.ltxprogrammer.changed.client.renderer.layers.GasMaskLayer;
import net.ltxprogrammer.changed.client.renderer.layers.LatexParticlesLayer;
import net.ltxprogrammer.changed.client.renderer.layers.TransfurCapeLayer;
import net.ltxprogrammer.changed.client.renderer.model.armor.ArmorLatexMaleWolfModel;
import net.minecraft.client.renderer.entity.EntityRendererProvider;
import net.minecraft.resources.ResourceLocation;

public class LatexCheetahMaleRenderer extends AdvancedHumanoidRenderer< LatexCheetahMale, LatexCheetahMaleModel >
{
	public static final ResourceLocation DEFAULT_SKIN_LOCATION = BakersTransfurs.modResource("textures/entity/latex_cheetah_male.png");
	
	public LatexCheetahMaleRenderer(EntityRendererProvider.Context context) {
		super(context, new LatexCheetahMaleModel(context.bakeLayer(LatexCheetahMaleModel.LAYER_LOCATION)), ArmorLatexMaleWolfModel.MODEL_SET, 0.5f);
		this.addLayer(new LatexParticlesLayer<>(this, getModel()));
		this.addLayer(TransfurCapeLayer.normalCape(this, context.getModelSet()));
		this.addLayer(CustomEyesLayer.builder(this, context.getModelSet()).build());
		this.addLayer(GasMaskLayer.forSnouted(this, context.getModelSet()));
	}
	
	@Override
	public ResourceLocation getTextureLocation(LatexCheetahMale pEntity) { return DEFAULT_SKIN_LOCATION; }
}
