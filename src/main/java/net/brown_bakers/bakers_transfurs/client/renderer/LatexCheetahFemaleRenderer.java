package net.brown_bakers.bakers_transfurs.client.renderer;

import net.brown_bakers.bakers_transfurs.BakersTransfurs;
import net.brown_bakers.bakers_transfurs.client.renderer.model.LatexCheetahFemaleModel;
import net.brown_bakers.bakers_transfurs.entity.LatexCheetahFemale;
import net.ltxprogrammer.changed.client.renderer.AdvancedHumanoidRenderer;
import net.ltxprogrammer.changed.client.renderer.layers.CustomEyesLayer;
import net.ltxprogrammer.changed.client.renderer.layers.GasMaskLayer;
import net.ltxprogrammer.changed.client.renderer.layers.LatexParticlesLayer;
import net.ltxprogrammer.changed.client.renderer.layers.TransfurCapeLayer;
import net.ltxprogrammer.changed.client.renderer.model.armor.ArmorLatexFemaleWolfModel;
import net.minecraft.client.renderer.entity.EntityRendererProvider;
import net.minecraft.resources.ResourceLocation;

public class LatexCheetahFemaleRenderer extends AdvancedHumanoidRenderer<LatexCheetahFemale, LatexCheetahFemaleModel> {
	public static final ResourceLocation DEFAULT_SKIN_LOCATION = BakersTransfurs.modResource("textures/entity/latex_cheetah_female.png");
	
	public LatexCheetahFemaleRenderer(EntityRendererProvider.Context context) {
		super(context, new LatexCheetahFemaleModel(context.bakeLayer(LatexCheetahFemaleModel.LAYER_LOCATION)), ArmorLatexFemaleWolfModel.MODEL_SET, 0.5f);
		this.addLayer(new LatexParticlesLayer<>(this, getModel()));
		this.addLayer(TransfurCapeLayer.normalCape(this, context.getModelSet()));
		this.addLayer(CustomEyesLayer.builder(this, context.getModelSet()).build());
		this.addLayer(GasMaskLayer.forSnouted(this, context.getModelSet()));
	}
	
	@Override
	public ResourceLocation getTextureLocation(LatexCheetahFemale pEntity) { return DEFAULT_SKIN_LOCATION; }
}
