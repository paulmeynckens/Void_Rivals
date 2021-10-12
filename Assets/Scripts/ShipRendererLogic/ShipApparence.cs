using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using RoundManagement;
using System;
using Mirror;

namespace ShipsRenderer
{
    public class ShipApparence : MonoBehaviour
    {
        [SerializeField] GameObject[] changingNames = null;
        [SerializeField] TextMesh textMesh = null;

        [SerializeField] RendererGroup[] rendererGroups;


        private void Awake()
        {
            LinkToNetId linkToNetId = GetComponentInParent<LinkToNetId>();
            if (linkToNetId != null)
            {
                linkToNetId.OnClientLinkEstablished += SearchCrewAndSetApparence;
            }
        }

        void SearchCrewAndSetApparence(uint targetCrewId)
        {
            Crew crew = NetworkIdentity.spawned[targetCrewId].GetComponent<Crew>();

            ChangeColor(crew.team);

            string shipName = NetworkIdentity.spawned[crew.captain].GetComponent<PlayerPawn>().playerData.shipName;
            ChangeName(shipName);
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
        }


        void ChangeName(string _new)
        {
            foreach(GameObject changingName in changingNames)
            {
                string name = changingName.name;
                changingName.name = _new + " (" + name + ")";
            }
            if (textMesh != null)
            {
                textMesh.text = _new;
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
