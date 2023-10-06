# resonite-substance-support
 A set of presets and shaders intended to create parity between Resonite and the Adobe Substance Suite

# Google Docs Version
I intend to keep both up to date, just in case the google docs formatting might be preferred I'll leave it here
https://docs.google.com/document/d/1xmrEwwOXCwkXStHgxy2dNJ3G31Ubr0eJXyiVDEvj_oQ/edit?usp=sharing


# Using Substance Painter with Resonite


**Version: 1.1**

# Installation:
```
Export presets go in the following folder:
~\Documents\Adobe\Adobe Substance 3D Painter\assets\export-presets
Shaders go in the following folder:
~\Documents\Adobe\Adobe Substance 3D Painter\assets\shaders
Templates go in the following folder:
~\Documents\Adobe\Adobe Substance 3D Painter\assets\templates
```
Once all of this is done you should be good to go, be sure to read the following research guides below. 



# Authoring with Metallic:
On startup please pick one of the following templates:



* <code>PBR - Metallic Roughness Alpha-blend</code></strong>
* <strong><code>PBR - Metallic Roughness Alpha-test</code></strong>


Both of these templates are calibrated to work with metallic. Alpha-test is intended to be used to author materials with the "Cutout" or "AlphaClip" blendmode. Alpha-blend is intended to be used to author materials with the "Alpha" or "AlphaBlend" blendmode. Both can be used to author Opaque materials just don't paint with opacity.

This is the standard substance workflow, where it diverges in regards to the export.

To assist in this I have added the following 4 export templates:




* <code>Resonite Metallic Packed Height</code></strong>
* <strong><code>Resonite Metallic Packed Occlusion</code></strong>
* <strong><code>Resonite Metallic Variant</code></strong>
* <strong><code>Resonite Metallic Verbose</code></strong>


To understand why there need to be this many metallic export templates let me explain the unique quirks of how channel packing works in Resonite.

In the unity standard Metallic Maps (called Mask Maps) are composed of the following channels
```
  R - Metallic Map
  G - Ambient Occlusion Map or Height Map
  B - Detail Mask
  A - Smoothness
```
In Resonite we use a slightly outdated standard that goes as follows:
```
  R - Metallic Map
  G - Ambient Occlusion Map or Height Map
  B - Nothing
  A - Smoothness
```
To cover all the bases without duplicate information we need two export presets. One where ambient occlusion is packed into the green and one where height is packed into the green.

The following templates serve those purposes:

* <code>Resonite Metallic Packed Height</code></strong>
* <strong><code>Resonite Metallic Packed Occlusion</code></strong>

This would be where it ended, but unfortunately there is a discrepancy between the base PBS_Metallic shader and the rest of the shaders in the game. Whereas base PBS_Metallic reads ambient occlusion and height from the green channel all the variants read it from the red channel.

In case you're curious variants are defined as the following:

```
* PBS Color Mask Metallic
* PBS Color Splat Metallic
* PBS Displace Metallic
* PBS Distance Lerp Metallic
* PBS Dual Sided Metallic
* PBS Intersect Metallic
* PBS Multi UV Metallic
* PBS Rim Metallic
*`PBS Slice Metallic
* PBS Stencil Metallic
* PBS Triplanar Metallic
* PBS Vertex Color Metallic
* PBSLerp Metallic
* Xiexie Toon
```
So basically every shader that isn't the base form of PBS_Metallic, and Xiexie toon since it supports a Metallic Map.

For these the Resonite Metallic Variant export preset is needed. This keeps the ambient occlusion map separate and creates a metallic map with only metalness and smoothness, saving you a channel of data.

In situations where you are unsure what combination of packs you will need, Resonite Metallic Verbose will suffice since it exports all possible combinations, however it also exports all 3 possible metallic configurations and if you're space conscious this can be an issue.



# Authoring in Specular:

Specular required a much larger overhaul to get working because the way Resonite's specular shader works is fundamentally different from Substance Painter's shader. To fix this I created a set of shaders to emulate the Resonite look.

On startup please pick one of the following templates:


* <code>Resonite - Specular Glossiness Alpha Blend</code></strong>
* <strong><code>Resonite - Specular Glossiness Cutout</code></strong>

Both of these templates are calibrated to work with Specular. Cutout  is intended to be used to author materials with the "Cutout" or "AlphaClip" blendmode. Alpha Blend is intended to be used to author materials with the "Alpha" or "AlphaBlend" blendmode. Both can be used to author Opaque materials just don't paint with opacity.

Thankfully when it comes to export it's absurdly easy. Due to less complex channel packing there is only one export preset.

* <code>Resonite Specular</code></strong>
