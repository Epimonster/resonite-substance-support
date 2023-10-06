/*************************************************************************
* ADOBE CONFIDENTIAL
* ___________________
* Copyright 2017 Adobe
* All Rights Reserved.
* NOTICE:  All information contained herein is, and remains
* the property of Adobe and its suppliers, if any. The intellectual
* and technical concepts contained herein are proprietary to Adobe
* and its suppliers and are protected by all applicable intellectual
* property laws, including trade secret and copyright laws.
* Dissemination of this information or reproduction of this material
* is strictly forbidden unless prior written permission is obtained
* from Adobe.
*************************************************************************/

//- Substance 3D Painter Specular/Glossiness PBR shader
//- ============================================
//-
//- MODIFIED BY GARETH48 SO IT WORKS IN RESONITE LETS GOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
//- THEN AGAIN SO IT SUPPORTS ALPHA SUBSTANCE WHY ARE YOU LIKE THIS
//- Import from libraries.
import lib-pbr.glsl
import lib-bent-normal.glsl
import lib-emissive.glsl
import lib-pom.glsl
import lib-sss.glsl
import lib-utils.glsl

// Link Specular/Glossiness skin MDL for Iray
//: metadata {
//:   "mdl" : "mdl::alg::materials::skin_specular_glossiness::skin_specular_glossiness"
//: }

//- Show back faces as there may be holes in front faces.
//: state cull_face off

//- Enable alpha blending
//: state blend over

//- Channels needed for spec/gloss workflow are bound here.
//: param auto channel_diffuse
uniform SamplerSparse diffuse_tex;
//: param auto channel_specular
uniform SamplerSparse specularcolor_tex;
//: param auto channel_glossiness
uniform SamplerSparse glossiness_tex;
//: param auto channel_opacity
uniform SamplerSparse opacity_tex;

void shade(V2F inputs)
{
  // Apply parallax occlusion mapping if possible
  vec3 viewTS = worldSpaceToTangentSpace(getEyeVec(inputs.position), inputs);
  applyParallaxOffset(inputs, viewTS);

  float glossiness = getGlossiness(glossiness_tex, inputs.sparse_coord);
  vec3 specColor = getSpecularColor(specularcolor_tex, inputs.sparse_coord);
  vec3 diffColor = getDiffuse(diffuse_tex, inputs.sparse_coord) * (vec3(1.0) - specColor);
  float diffuseReduction = max(max(specColor.r,specColor.g), specColor.b);
	diffColor = mix(diffColor, vec3(0,0,0), diffuseReduction);

  // Get detail (ambient occlusion) and global (shadow) occlusion factors
  // separately in order to blend the bent normals properly
  float shadowFactor = getShadowFactor();
  float occlusion = getAO(inputs.sparse_coord, true, use_bent_normal);
  float specOcclusion = use_bent_normal ? shadowFactor : occlusion * shadowFactor;

  LocalVectors vectors = computeLocalFrame(inputs);
  computeBentNormal(vectors,inputs);

  // Feed parameters for a physically based BRDF integration
  alphaOutput(getOpacity(opacity_tex, inputs.sparse_coord));
  emissiveColorOutput(pbrComputeEmissive(emissive_tex, inputs.sparse_coord));
  albedoOutput(diffColor);
  diffuseShadingOutput(occlusion * shadowFactor * envIrradiance(getDiffuseBentNormal(vectors)));
  specularShadingOutput(specOcclusion * pbrComputeSpecular(vectors, specColor, 1.0 - glossiness, occlusion, getBentNormalSpecularAmount()));
  sssCoefficientsOutput(getSSSCoefficients(inputs.sparse_coord));
  sssColorOutput(getSSSColor(inputs.sparse_coord));
}
