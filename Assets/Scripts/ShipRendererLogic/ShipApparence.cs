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
        [SerializeField] ShipSpawnedStateManager shipStateManager = null;
        Crew crew=null;
        Target target;

        private void Awake()
        {
            target = GetComponent<Target>();
            /*
            if (linkToNetId != null)
            {
                linkToNetId.OnClientLinkEstablished += SearchCrewAndSetApparence;
            }
            */
        }



        private void OnEnable()
        {
            SearchCrewAndSetApparence(shipStateManager.ShipCrewNetId);
        }
        void SearchCrewAndSetApparence(uint targetCrewId)
        {
            if (targetCrewId == 0)
            {
                return;
            }
            StartCoroutine(SearchCrew(targetCrewId));
            
            
        }
        IEnumerator SearchCrew(uint targetCrewId)
        {
            while (crew == null)
            {
                yield return null;
                
                if (NetworkIdentity.spawned.TryGetValue(targetCrewId, out NetworkIdentity identity))
                {
                    crew = identity.GetComponent<Crew>();
                    ChangeColor(crew.team);
                    //ChangeName(shipName);
                    //string shipName = NetworkIdentity.spawned[crew.captain].GetComponent<PlayerPawn>().playerData.shipName;
                }
                    
            }
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
