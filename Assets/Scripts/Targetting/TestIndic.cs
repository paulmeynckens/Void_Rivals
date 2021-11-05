using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace Targetting
{
    //[DefaultExecutionOrder(-1)]

    /// <summary>
    /// / test indicateur
    /// </summary>
    public class TestIndic : TargetManager
    {
        //( repris de offscreenIndicator
        [Range(0.5f, 0.9f)]
        [Tooltip("Distance offset of the indicators from the centre of the screen")]
        [SerializeField] private float screenBoundOffset = 0.9f;

        private Camera mainCamera;
        private Vector3 screenCentre;
        private Vector3 screenBounds;

        [SerializeField]bool mustDraw = true; // serialise for debugging
        public bool MustDraw
        {
            set
            {
                mustDraw = value;
            }
        }

        void Awake()
        {
            mainCamera = Camera.main;
            screenCentre = new Vector3(Screen.width, Screen.height, 0) / 2;
            screenBounds = screenCentre * screenBoundOffset;
        }

        // //////////////
        public override void DrawIndicators()
        {
            Vector3 screenPosition = OffScreenIndicatorCore.GetScreenPosition(mainCamera, target.transform.position);
            bool isTargetVisible = OffScreenIndicatorCore.IsTargetVisible(screenPosition);
            float distanceFromCamera = Vector3.Distance(mainCamera.transform.position, target.transform.position);

            Indicator indicator = null;


            if (mustDraw)
            {
                if (isTargetVisible)
                {
                    screenPosition.z = 0;
                    indicator = target.GetIndicator(0);

                    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                    indicator.Activate(true);
                    target.GetIndicator(1).Activate(false);
                    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

                }
                else
                {
                    float angle = float.MinValue;
                    OffScreenIndicatorCore.GetArrowIndicatorPositionAndAngle(ref screenPosition, ref angle, screenCentre, screenBounds);

                    indicator = target.GetIndicator(1);
                    indicator.transform.rotation = Quaternion.Euler(0, 0, angle * Mathf.Rad2Deg);
                    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                    indicator.Activate(true);
                    target.GetIndicator(0).Activate(false);
                    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

                }
            }

            

            if (indicator)
            {
                
                //indicator.SetImageColor(target.TargetColor);// Sets the image color of the indicator.
                indicator.SetDistanceText(distanceFromCamera); //Set the distance text for the indicator.
                indicator.transform.position = screenPosition; //Sets the position of the indicator on the screen.
                indicator.SetTextRotation(Quaternion.identity); // Sets the rotation of the distance text of the indicator.
            }


        }
    }
}
