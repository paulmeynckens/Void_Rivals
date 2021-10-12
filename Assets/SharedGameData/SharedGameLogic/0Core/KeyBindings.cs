using System.Collections.Generic;
using UnityEngine;

namespace Core
{
    public static class KeyBindings
    {
        public static float m_mouseSensitivity = 150;

        public static Dictionary<Actions, KeyCode> Pairs = new Dictionary<Actions, KeyCode>()
    {
            {Actions.forward,(KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(Actions.forward.ToString(),KeyCode.W.ToString())) },
            {Actions.backward,(KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(Actions.backward.ToString(),KeyCode.S.ToString())) },
            {Actions.left,(KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(Actions.left.ToString(),KeyCode.A.ToString())) },
            {Actions.right,(KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(Actions.right.ToString(),KeyCode.D.ToString()))},
            {Actions.rollLeft,(KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(Actions.rollLeft.ToString(),KeyCode.Q.ToString())) },
            {Actions.rollRight,(KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(Actions.rollRight.ToString(),KeyCode.E.ToString()))},
            {Actions.dock,(KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(Actions.dock.ToString(),KeyCode.T.ToString()))},

            {Actions.jump, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(Actions.jump.ToString(),KeyCode.Space.ToString()))},
            {Actions.crouch, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(Actions.crouch.ToString(),KeyCode.LeftControl.ToString())) },
            {Actions.run, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(Actions.run.ToString(),KeyCode.LeftShift.ToString())) },

            {Actions.hud, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(Actions.hud.ToString(),KeyCode.Q.ToString())) },
            {Actions.interact,(KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(Actions.interact.ToString(),KeyCode.E.ToString())) },
            {Actions.exit_seat,(KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(Actions.exit_seat.ToString(),KeyCode.F.ToString())) },
            {Actions.in_game_menu, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(Actions.in_game_menu.ToString(),KeyCode.Escape.ToString())) },
            {Actions.teams_screen, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(Actions.teams_screen.ToString(),KeyCode.Tab.ToString())) },
            {Actions.shoot, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(Actions.shoot.ToString(),KeyCode.Mouse0.ToString())) },
            {Actions.aim, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(Actions.aim.ToString(),KeyCode.Mouse1.ToString())) },

            {Actions.left_weapon, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(Actions.left_weapon.ToString(),KeyCode.Alpha1.ToString())) },
            {Actions.rigth_weapon, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(Actions.rigth_weapon.ToString(),KeyCode.Alpha3.ToString())) },
            {Actions.both_weapons, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(Actions.both_weapons.ToString(),KeyCode.Alpha2.ToString())) },

            {Actions.release_cursor, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(Actions.release_cursor.ToString(),KeyCode.M.ToString())) },

            {Actions.item_slot1, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(Actions.item_slot1.ToString(),KeyCode.Alpha1.ToString())) },
            {Actions.item_slot2, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(Actions.item_slot2.ToString(),KeyCode.Alpha2.ToString())) },
            {Actions.item_slot3, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(Actions.item_slot3.ToString(),KeyCode.Alpha3.ToString())) },
            {Actions.item_slot4, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(Actions.item_slot4.ToString(),KeyCode.Alpha4.ToString())) },

    };


        public static void SavePlayerPrefs()
        {
            foreach (var pref in Pairs)
            {
                PlayerPrefs.SetString(pref.Key.ToString(), pref.Value.ToString());
            }
        }


    }

    public enum Actions
    {
        hud,
        teams_screen,
        in_game_menu,

        forward,
        backward,
        left,
        right,

        rollLeft,
        rollRight,
        dock,

        jump,
        crouch,
        run,

        

        interact,
        exit_seat,


        shoot,
        aim,

        left_weapon,
        rigth_weapon,
        both_weapons,

        release_cursor,

        

        item_slot1,
        item_slot2,
        item_slot3,
        item_slot4,
    }
}
