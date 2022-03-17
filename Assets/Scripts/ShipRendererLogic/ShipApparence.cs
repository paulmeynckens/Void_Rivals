using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using RoundManagement;
using System;
using Mirror;
using TMPro;

namespace ShipsRenderer
{
    public class ShipApparence : MonoBehaviour
    {
        [SerializeField] GameObject[] changingNames = null;
        [SerializeField] TMP_Text shipNameText = null;

        [SerializeField] RendererGroup[] rendererGroups;
        [SerializeField] ShipPawn shipPawn = null;
        
        Target target;

        private void Awake()
        {
            target = GetComponent<Target>();

        }



        private void OnEnable()
        {
            Crew newCrew = shipPawn.CrewId.GetComponent<Crew>();
            ChangeColor(newCrew.Team);
        }
        

        void ChangeColor(bool _new)
        {
            foreach(RendererGroup rendererGroup in rendererGroups)
            {
                foreach(Renderer renderer in rendererGroup.renderers)
                {
                    if (_new)
                    {
                        renderer.material = rendererGroup.blue;

                    }
                    else
                    {
                        renderer.material = rendererGroup.red;
                    }
                }
            }

            if (_new)
            {
                target.TargetColor = Color.blue;
            }
            else
            {
                target.TargetColor = Color.red;
            }
        }


        void ChangeName(string _new)
        {
            foreach(GameObject changingName in changingNames)
            {
                string name = changingName.name;
                changingName.name = _new + " (" + name + ")";
            }
            if (shipNameText != null)
            {
                shipNameText.text = _new;
            }

        }



    }

    [Serializable]
    public struct RendererGroup
    {
        public Material blue;
        public Material red;

        public List<Renderer> renderers;
    }
}
