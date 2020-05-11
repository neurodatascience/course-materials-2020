def run_fancy_dti_analyzes():


            # Enables/disables interactive visualization
            interactive = False

            from dipy.core.gradients import gradient_table
            from dipy.data import get_fnames
            from dipy.io.gradients import read_bvals_bvecs
            from dipy.io.image import load_nifti, load_nifti_data

            hardi_fname, hardi_bval_fname, hardi_bvec_fname = get_fnames('stanford_hardi')
            label_fname = get_fnames('stanford_labels')

            data, affine, hardi_img = load_nifti(hardi_fname, return_img=True)
            labels = load_nifti_data(label_fname)
            bvals, bvecs = read_bvals_bvecs(hardi_bval_fname, hardi_bvec_fname)
            gtab = gradient_table(bvals, bvecs)

            white_matter = (labels == 1) | (labels == 2)

            from dipy.reconst.csdeconv import auto_response
            from dipy.reconst.shm import CsaOdfModel
            from dipy.data import default_sphere
            from dipy.direction import peaks_from_model

            response, ratio = auto_response(gtab, data, roi_radius=10, fa_thr=0.7)
            csa_model = CsaOdfModel(gtab, sh_order=6)
            csa_peaks = peaks_from_model(csa_model, data, default_sphere,
                                        relative_peak_threshold=.8,
                                        min_separation_angle=45,
                                        mask=white_matter)
            from dipy.viz import window, actor, has_fury

            if has_fury:
                ren = window.Renderer()
                ren.add(actor.peak_slicer(csa_peaks.peak_dirs,
                                        csa_peaks.peak_values,
                                        colors=None))

                window.record(ren, out_path='csa_direction_field.png', size=(900, 900))

                if interactive:
                    window.show(ren, size=(800, 800))

            from dipy.tracking.stopping_criterion import ThresholdStoppingCriterion

            stopping_criterion = ThresholdStoppingCriterion(csa_peaks.gfa, .25)

            import matplotlib.pyplot as plt

            sli = csa_peaks.gfa.shape[2] // 2
            plt.figure('GFA')
            plt.subplot(1, 2, 1).set_axis_off()
            plt.imshow(csa_peaks.gfa[:, :, sli].T, cmap='gray', origin='lower')

            plt.subplot(1, 2, 2).set_axis_off()
            plt.imshow((csa_peaks.gfa[:, :, sli] > 0.25).T, cmap='gray', origin='lower')

            plt.savefig('gfa_tracking_mask.png')

            from dipy.tracking import utils

            seed_mask = (labels == 2)
            seeds = utils.seeds_from_mask(seed_mask, affine, density=[2, 2, 2])

            from dipy.tracking.local_tracking import LocalTracking
            from dipy.tracking.streamline import Streamlines

            # Initialization of LocalTracking. The computation happens in the next step.
            streamlines_generator = LocalTracking(csa_peaks, stopping_criterion, seeds,
                                                affine=affine, step_size=.5)
            # Generate streamlines object
            streamlines = Streamlines(streamlines_generator)

            from dipy.viz import colormap

            if has_fury:
                # Prepare the display objects.
                color = colormap.line_colors(streamlines)

                streamlines_actor = actor.line(streamlines,
                                            colormap.line_colors(streamlines))

                # Create the 3D display.
                r = window.Renderer()
                r.add(streamlines_actor)

                # Save still images for this static example. Or for interactivity use
                window.record(r, out_path='tractogram_EuDX.png', size=(800, 800))
                if interactive:
                    window.show(r)

            from dipy.io.stateful_tractogram import Space, StatefulTractogram
            from dipy.io.streamline import save_trk

            sft = StatefulTractogram(streamlines, hardi_img, Space.RASMM)
            save_trk(sft, "tractogram_EuDX.trk", streamlines)

if __name__ == "__main__":

    run_fancy_dti_analyzes() 
